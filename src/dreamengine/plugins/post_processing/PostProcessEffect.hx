package dreamengine.plugins.post_processing;

import kha.Image;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.FragmentShader;
import kha.graphics4.PipelineState;

class PostProcessEffect {
	public var enabled = true;

	var passes:Array<PostProcessEffectPass>;

	public function new() {
		passes = createPasses();
	}

	function createPasses():Array<PostProcessEffectPass> {
		return [new SimplePostProcessPass()];
	}

	function sendValues(destination:Image) {}

	public function execute(source:Image, destination:Image) {
		var last:Image = source;
		for (i in 0...passes.length) {
			var p = passes[i];
			var current = p.createRenderTarget(last);


			var pipeline = p.getPipeline();
			current.g2.begin();
			current.g4.setPipeline(pipeline);
			current.g2.pipeline = pipeline;
			sendValues(current);
			current.g4.setTexture(pipeline.getTextureUnit("base"), source);
			kha.Scaler.scale(last, current, kha.System.screenRotation);
			current.g2.end();

			if (last != null && last != source)
				last.unload();

			last = current;
		}

		destination.g2.begin();
		kha.Scaler.scale(last, destination, kha.System.screenRotation);
		destination.g2.end();

		last.unload();
	}
}
