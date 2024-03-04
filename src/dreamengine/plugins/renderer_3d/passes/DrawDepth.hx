package dreamengine.plugins.renderer_3d.passes;

import kha.graphics4.ConstantLocation;
import kha.graphics4.VertexStructure;
import kha.Shaders;
import kha.graphics4.PipelineState;
import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class DrawDepth extends RenderPass {
	var pipelineState:PipelineState;
	var mvpLocation:ConstantLocation;
	var modelLocation:ConstantLocation;

	public function new() {
		super();
		pipelineState = new PipelineState();
		pipelineState.vertexShader = Shaders.simple_vert;
		pipelineState.fragmentShader = Shaders.depth_frag;
		pipelineState.depthMode = Less;
		pipelineState.depthWrite = true;
		pipelineState.cullMode = Clockwise;
		var structure = new VertexStructure();
		structure.add("vertexPosition", Float3);
		pipelineState.inputLayout = [structure];
		pipelineState.compile();

		mvpLocation = pipelineState.getConstantLocation("MVP");
		modelLocation = pipelineState.getConstantLocation("Model");
	}

	override function execute(renderer:Renderer) {
		for (camera in renderer.cameras) {
			var g = camera.depthTexture.g4;
			g.begin();
			g.clear(White, Math.POSITIVE_INFINITY);
			for (renderable in renderer.opaques) {
				g.setPipeline(pipelineState);
				g.setVertexBuffer(renderable.mesh.getVertexBuffer());
				g.setIndexBuffer(renderable.mesh.getIndexBuffer());

				var mvp = camera.getViewProjectionMatrix().multmat(renderable.modelMatrix);
				g.setMatrix(mvpLocation, mvp);
				g.setMatrix(modelLocation, renderable.modelMatrix);

				g.drawIndexedVertices();
			}
			g.end();
		}
	}
}
