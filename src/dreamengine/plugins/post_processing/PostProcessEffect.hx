package dreamengine.plugins.post_processing;

import kha.Scaler;
import kha.graphics5_.TextureFormat;
import dreamengine.device.Screen;
import kha.Image;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.FragmentShader;
import kha.graphics4.PipelineState;

class PostProcessEffect {
	public var enabled = true;

	var passes:Array<PostProcessEffectPass>;

	var intermediate:Image;

	public function new() {
		passes = createPasses();
	}

	function createPasses():Array<PostProcessEffectPass> {
		return [new SimplePostProcessPass()];
	}

	public function getIntermediate(){
		return intermediate;
	}
	public function createIntermediate(){
		var res = Screen.getResolution();
		intermediate = Image.createRenderTarget(res.x, res.y);
		return intermediate;
	}

	function sendValues(destination:Image) {}

	public function execute(source:Image, destination: Image, screen:Image) {
		for (i in 0...passes.length) {
			var p = passes[i];

			var pipeline = p.getPipeline();
			destination.g2.begin(false);
			destination.g4.setPipeline(pipeline);
			destination.g2.pipeline = pipeline;
			sendValues(destination);
			destination.g4.setTexture(pipeline.getTextureUnit("sceneTexture"), screen);
			p.passValues(destination.g4);
			
			Scaler.scale(source, destination, kha.System.screenRotation);

			destination.g2.end();

		}
	}
}
