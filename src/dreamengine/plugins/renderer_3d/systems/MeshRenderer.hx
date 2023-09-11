package dreamengine.plugins.renderer_3d.systems;

import kha.math.FastVector4;
import dreamengine.plugins.renderer_base.components.Material;
import dreamengine.plugins.ecs.ECSContext;
import kha.Assets;
import dreamengine.plugins.renderer_3d.loaders.ObjLoader;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import kha.math.Vector3;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.renderer_2d.components.Transform2D;
import kha.graphics4.PipelineState;
import kha.graphics4.CompareMode;
import kha.Shaders;
import kha.math.FastMatrix4;
import kha.math.FastMatrix3;
import kha.graphics4.IndexBuffer;
import kha.graphics5_.VertexStructure;
import kha.graphics5_.Usage;
import kha.graphics4.VertexBuffer;
import dreamengine.plugins.renderer_3d.components.Mesh;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class MeshRenderer extends RenderSystem {
	var lastRendered:RenderContext = null;

	public function new() {
		super();
	}

	override function execute(ecsContext:ECSContext, renderContext:RenderContext) {
		var g4 = renderContext.getRenderTarget().g4;

		var f = ecsContext.query([new With(Mesh), new With(Transform), new Optional(Material)]);

		for (c in f) {
			var mesh:Mesh = c.getComponent(Mesh);
			var transform:Transform = c.getComponent(Transform);
			var material:Material = c.getComponent(Material);

			var pipelineState:PipelineState = renderContext.getPipelineState();

			var positions = mesh.getVertices();
			var uvs = mesh.getUVs();
			var normals = mesh.getNormals();

			var struct = new VertexStructure();
			struct.add("vertexPosition", Float3);
			struct.add("uv", Float2);
			struct.add("vertexNormal", Float3);
			var structLength = Std.int(struct.byteSize() / 4);

			pipelineState.inputLayout = [struct];

			if (material != null) {
				pipelineState.vertexShader = material.getVertexShader();
				pipelineState.fragmentShader = material.getFragmentShader();
				pipelineState.cullMode = material.cullMode;
			} else {
				pipelineState.vertexShader = Shaders.simple_vert;
				pipelineState.fragmentShader = Shaders.simple_frag;
				pipelineState.cullMode = Clockwise;
			}


			pipelineState.depthWrite = true;
			pipelineState.depthMode = CompareMode.Less;
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

			var indexBuffer = new IndexBuffer(mesh.getIndices().length, Usage.StaticUsage);

			var iData = indexBuffer.lock();

			for (i in 0...iData.length) {
				iData[i] = mesh.getIndices()[i];
			}

			indexBuffer.unlock();

			var model = transform.localMatrix;
			var mvp = renderContext.getRenderView().getViewProjectionMatrix().multmat(model);

			g4.setVertexBuffer(vertexBuffer);
			g4.setIndexBuffer(indexBuffer);

			g4.setPipeline(pipelineState);
			g4.setMatrix(pipelineState.getConstantLocation("MVP"), mvp);
			g4.setMatrix(pipelineState.getConstantLocation("M"), model);
			g4.setMatrix(pipelineState.getConstantLocation("V"), renderContext.getRenderView().getViewMatrix());
			ShaderGlobals.apply(pipelineState, g4);

			// do setting material properties
			g4.setVector4(pipelineState.getConstantLocation("baseColor"), new FastVector4(0,0,1,1));


			// g4.drawIndexedVerticesInstanced(100);
			g4.drawIndexedVertices();
		}
	}
}
