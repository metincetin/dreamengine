package dreamengine.plugins.post_processing;

import kha.Image;
import kha.graphics4.*;

class PostProcessEffectPass {
	var pipeline:PipelineState;

	var enabled = true;

	var renderTarget:Image;

	public function new() {
		createPipeline();
	}

	function getShader():FragmentShader {
		return kha.Shaders.painter_image_frag;
	}

	function createPipeline() {
		pipeline = new PipelineState();
		var structure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float32_3X);
		structure.add("vertexUV", VertexData.Float32_2X);
		structure.add("vertexColor", VertexData.UInt8_4X_Normalized);
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = kha.Shaders.painter_image_vert;
		pipeline.fragmentShader = getShader();

		pipeline.compile();
	}

	public function getRenderTarget(){
		return renderTarget;
	}

	public function createRenderTarget(source:Image){
		renderTarget = Image.createRenderTarget(source.width, source.height, source.format);
		return renderTarget;
	}

	public function getPipeline(){
		return pipeline;
	}

	public function passValues(graphics:Graphics) {
	}
}