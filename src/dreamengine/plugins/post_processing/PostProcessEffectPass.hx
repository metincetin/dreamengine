package dreamengine.plugins.post_processing;

import dreamengine.plugins.renderer_base.components.Camera;
import kha.Image;
import kha.graphics4.*;

class PostProcessEffectPass {
	var pipeline:PipelineState;

	var enabled = true;

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

	public function getCustomRenderTarget(): Image{
		return null;
	}

	public function getPipeline(){
		return pipeline;
	}

	public function passValues(graphics:Graphics, camera:Camera) {
	}
}