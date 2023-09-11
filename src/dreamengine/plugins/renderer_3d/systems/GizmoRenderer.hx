package dreamengine.plugins.renderer_3d.systems;

import dreamengine.core.math.Vector3;
import dreamengine.core.math.Mathf;
import kha.math.FastMatrix4;
import kha.Shaders;
import kha.graphics4.*;
import dreamengine.plugins.renderer_3d.components.*;
import dreamengine.plugins.renderer_base.components.*;
import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.ecs.System.RenderContext;
import dreamengine.plugins.ecs.System.RenderSystem;

class GizmoRenderer extends RenderSystem {
	var gizmo:Mesh;

	public function new() {
		super();
		gizmo = Primitives.cube();
	}

	override function execute(ecsContext:ECSContext, renderContext:RenderContext) {
		var f = ecsContext.query([
			new With(Transform),
			new Without(Camera),
			new Optional(Mesh),
			new Optional(DirectionalLight)
		]);
		var g4 = renderContext.getRenderTarget().g4;
		for (c in f) {
			var transform:Transform = c.getComponent(Transform);

			var pipelineState:PipelineState = renderContext.getPipelineState();

			var positions = gizmo.getVertices();
			var uvs = gizmo.getUVs();
			var normals = gizmo.getNormals();

			var struct = new VertexStructure();
			struct.add("vertexPosition", Float3);
			struct.add("uv", Float2);
			struct.add("vertexNormal", Float3);
			var structLength = Std.int(struct.byteSize() / 4);

			pipelineState.inputLayout = [struct];

			pipelineState.vertexShader = Shaders.unlit_vert;
			pipelineState.fragmentShader = Shaders.unlit_frag;
			pipelineState.cullMode = Clockwise;

			pipelineState.depthWrite = true;
			pipelineState.depthMode = CompareMode.Always;
			pipelineState.compile();

			var vertsNum = Std.int(positions.length / 3);
			// Create vertex buffer
			var vertexBuffer = new VertexBuffer(vertsNum, // Vertex count - 3 floats per vertex
				struct, // Vertex structure
				Usage.StaticUsage // Vertex data will stay the same
			);

			// Copy vertices and colors to vertex buffer
			var vbData = vertexBuffer.lock();

			for (i in 0...vertsNum) {
				vbData.set((i * structLength) + 0, positions[(i * 3) + 0]);
				vbData.set((i * structLength) + 1, positions[(i * 3) + 1]);
				vbData.set((i * structLength) + 2, positions[(i * 3) + 2]);
				vbData.set((i * structLength) + 3, uvs[(i * 2) + 0]);
				vbData.set((i * structLength) + 4, uvs[(i * 2) + 1]);
				vbData.set((i * structLength) + 5, normals[(i * 3) + 0]);
				vbData.set((i * structLength) + 6, normals[(i * 3) + 1]);
				vbData.set((i * structLength) + 7, normals[(i * 3) + 2]);
			}

			vertexBuffer.unlock();

			var indexBuffer = new IndexBuffer(gizmo.getIndices().length, Usage.StaticUsage);

			var iData = indexBuffer.lock();

			for (i in 0...iData.length) {
				iData[i] = gizmo.getIndices()[i];
			}

			indexBuffer.unlock();


			var position = transform.getPosition();
			var rotation = transform.getRotation();

			var trMatrix = FastMatrix4.translation(position.x, position.y, position.z);
			var rotMatrix = rotation.toMatrix();
			var scale = new Vector3(0.2, 0.2, 0.2);
			if (c.getComponent(DirectionalLight) != null) {
				scale.z = 0.8;
			}
			var scaleMatrix = FastMatrix4.scale(scale.x, scale.y, scale.z);

			var m = trMatrix.multmat(rotMatrix).multmat(scaleMatrix);

			var mvp = renderContext.getRenderView().getViewProjectionMatrix().multmat(m);

			g4.setVertexBuffer(vertexBuffer);
			g4.setIndexBuffer(indexBuffer);

			g4.setPipeline(pipelineState);
			g4.setMatrix(pipelineState.getConstantLocation("MVP"), mvp);
			g4.setMatrix(pipelineState.getConstantLocation("M"), m);
			g4.setMatrix(pipelineState.getConstantLocation("V"), renderContext.getRenderView().getViewMatrix());

			// g4.drawIndexedVerticesInstanced(100);
			g4.drawIndexedVertices();
		}
	}
}
