package dreamengine.plugins.post_processing;

import dreamengine.plugins.renderer_base.components.Camera;
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
		createIntermediate();
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

	public function execute(source:Image, destination: Image, screen:Image, camera:Camera) {
		for (i in 0...passes.length) {
			var p = passes[i];


			var int = p.getCustomRenderTarget();
			if (int == null) int = intermediate;

			var pipeline = p.getPipeline();
			int.g2.begin();
			int.g4.setPipeline(pipeline);
			int.g2.pipeline = pipeline;
			int.g2.imageScaleQuality = High;
			int.g4.setTexture(pipeline.getTextureUnit("sceneTexture"), screen);
			p.passValues(int.g4, camera);
			sendValues(int, camera);
			
			Scaler.scale(source, int, kha.System.screenRotation);

			int.g2.end();

			source.g2.begin();
			source.g2.imageScaleQuality = High;
			Scaler.scale(int, source, kha.System.screenRotation);
			source.g2.end();
		}
		destination.g2.begin();
		Scaler.scale(source, destination, kha.System.screenRotation);
		destination.g2.end();
	}

	function sendValues(destination:Image, camera:Camera) {
	}
}
