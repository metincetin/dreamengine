package dreamengine.plugins.renderer_3d.systems;

import dreamengine.plugins.renderer_base.ShaderGlobals;
import dreamengine.plugins.renderer_3d.loaders.ObjLoader;
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
	var arrow:Mesh;
	var lastRendered:RenderContext = null;
	var lastMaterial:Material = null;
	var lastStruct:VertexStructure;
	var structLength = 0;


	public function new() {
		super();
		arrow = ObjLoader.load(kha.Assets.blobs.engine_gizmos_arrow_obj.toString());
		targetRenderContextProviders = [Renderer3D];
	}


	function createPipelineState(material:Material) {
		var pipelineState = new PipelineState();
		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		struct.add("uv", Float2);
		struct.add("vertexNormal", Float3);
		structLength = Std.int(struct.byteSize() / 4);

		pipelineState.inputLayout = [struct];

		pipelineState.vertexShader = Shaders.unlit_vert;
		pipelineState.fragmentShader = Shaders.unlit_frag;
		pipelineState.cullMode = Clockwise;

		lastStruct = struct;
		pipelineState.depthWrite = true;
		pipelineState.depthMode = CompareMode.Less;
		pipelineState.compile();

		return pipelineState;
	}

	override function execute(ecsContext:ECSContext, renderContext:RenderContext) {
		var g4 = renderContext.getRenderTarget().g4;

		var f = ecsContext.query([new With(DirectionalLight), new With(Transform), new Optional(Material)]);

		var pipelineState:PipelineState = renderContext.getPipelineState();
		if (f.length > 0){
				pipelineState = createPipelineState(f[0].getComponent(Material));
				renderContext.updatePipelineState(pipelineState);
				g4.setPipeline(pipelineState);
				ShaderGlobals.apply(pipelineState, g4);
		}

		g4.setPipeline(pipelineState);
		var mvpLocation = pipelineState.getConstantLocation("MVP");
		var vLocation = pipelineState.getConstantLocation("V");
		var mLocation = pipelineState.getConstantLocation("M");

		g4.setMatrix(vLocation, renderContext.getRenderView().getViewMatrix());

		for (c in f) {
			var mesh:Mesh = arrow;
			var transform:Transform = c.getComponent(Transform);
			var material:Material = c.getComponent(Material);

			var positions = mesh.getVertices();
			var uvs = mesh.getUVs();
			var normals = mesh.getNormals();

			if (pipelineState == null || lastStruct == null || lastMaterial != material) {
				pipelineState = createPipelineState(material);
				renderContext.updatePipelineState(pipelineState);
				g4.setPipeline(pipelineState);
				mvpLocation = pipelineState.getConstantLocation("MVP");
				vLocation = pipelineState.getConstantLocation("V");
				mLocation = pipelineState.getConstantLocation("M");

				g4.setMatrix(vLocation, renderContext.getRenderView().getViewMatrix());
			}

			var vertsNum = Std.int(positions.length / 3);
			// Create vertex buffer
			var vertexBuffer = new VertexBuffer(vertsNum, // Vertex count - 3 floats per vertex
				lastStruct, // Vertex structure
				Usage.StaticUsage// Vertex data will stay the same
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

			g4.setMatrix(mvpLocation, mvp);
			g4.setMatrix(mLocation, model);

			/*
				g4.setMatrix(pipelineState.getConstantLocation("MVP"), mvp);
				g4.setMatrix(pipelineState.getConstantLocation("M"), model);
				g4.setMatrix(pipelineState.getConstantLocation("V"), renderContext.getRenderView().getViewMatrix());
				ShaderGlobals.apply(pipelineState, g4);

				// do setting material properties
				g4.setVector4(pipelineState.getConstantLocation("baseColor"), new FastVector4(0, 0, 1, 1));
			 */

			ShaderGlobals.apply(pipelineState, g4);
				
			// g4.drawIndexedVerticesInstanced(100);
			g4.drawIndexedVertices();
			lastMaterial = material;
		}
	}
}