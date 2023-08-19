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

	function createPasses() :Array<PostProcessEffectPass>{
		return [new SimplePostProcessPass()];
	}

	function sendValues(destination:Image) {}

	public function execute(source:Image, destination:Image) {
		var last = destination;
		for (p in passes){

			var pipeline = p.getPipeline();
			last.g2.begin();
			last.g4.setPipeline(pipeline);
			last.g2.pipeline = pipeline;
			sendValues(last);
			kha.Scaler.scale(source, last, kha.System.screenRotation);
			last.g2.end();
			if (passes.length > 1){
				var r = last;
				last = p.createRenderTarget(last);
				last.unload();
			}
		}
		return last;
	}

}
