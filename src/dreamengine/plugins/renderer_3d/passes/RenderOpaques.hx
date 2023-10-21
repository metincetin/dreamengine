package dreamengine.plugins.renderer_3d.passes;

import dreamengine.plugins.renderer_base.ShaderGlobals;
import kha.math.FastVector4;
import kha.graphics4.VertexStructure;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import dreamengine.core.Renderable;
import dreamengine.plugins.renderer_base.Material;
import kha.graphics4.PipelineState;
import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class RenderOpaques extends RenderPass {

	var lastMaterial:Material = null;
	var lastStruct:VertexStructure;
	var structLength = 0;
	var pipelineState:PipelineState;

	function createPipelineState(material:Material) {
		var pipelineState = new PipelineState();
		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		struct.add("uv", Float2);
		struct.add("vertexNormal", Float3);
		structLength = Std.int(struct.byteSize() / 4);

		pipelineState.inputLayout = [struct];

		if (material == null) {
			material = Material.getDefault();
		}

		pipelineState.vertexShader = material.getVertexShader();
		pipelineState.fragmentShader = material.getFragmentShader();
		pipelineState.cullMode = material.cullMode;

		lastStruct = struct;
		pipelineState.depthWrite = material.depthWrite;
		pipelineState.depthMode = material.depthMode;
		pipelineState.compile();

		this.pipelineState = pipelineState;
	}

	override function execute(renderer:Renderer) {
		for (cam in renderer.cameras) {
			var g4 = cam.getRenderTarget().g4;
			g4.begin();
			g4.clear(null, 8);

			for (rend in renderer.opaques) {
				var mat = rend.material;

				if (mat == null) {
					mat = Material.getDefault();
				}

				if (pipelineState == null || lastMaterial != mat) {
					createPipelineState(mat);
				}

				g4.setPipeline(pipelineState);

				var mesh = rend.mesh;

				var positions = mesh.vertices;
				var uvs = mesh.uvs;
				var normals = mesh.normals;

				var vertsNum = Std.int(positions.length / 3);
				// Create vertex buffer
				var vertexBuffer = new VertexBuffer(vertsNum, // Vertex count - 3 floats per vertex
					lastStruct, // Vertex structure
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

				var indexBuffer = new kha.graphics4.IndexBuffer(mesh.indices.length, Usage.StaticUsage);

				var iData = indexBuffer.lock();

				for (i in 0...iData.length) {
					iData[i] = mesh.indices[i];
				}

				indexBuffer.unlock();

				g4.setVertexBuffer(vertexBuffer);
				g4.setIndexBuffer(indexBuffer);



				var mvp = cam.getViewProjectionMatrix().multmat(rend.modelMatrix);
				g4.setMatrix(pipelineState.getConstantLocation("Model"), rend.modelMatrix);
				g4.setMatrix(pipelineState.getConstantLocation("MVP"), mvp);
				ShaderGlobals.apply(pipelineState, g4);

				mat.applyParams(g4, pipelineState);

				g4.drawIndexedVertices();

				lastMaterial = mat;
			}
			g4.end();
		}
	}

	function render(renderable:Renderable, g4:kha.graphics4.Graphics) {}
}
