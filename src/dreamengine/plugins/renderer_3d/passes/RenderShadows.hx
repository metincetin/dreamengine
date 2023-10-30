package dreamengine.plugins.renderer_3d.passes;

import dreamengine.core.math.Vector3;
import dreamengine.plugins.renderer_base.components.Camera;
import kha.math.FastMatrix4;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import kha.Shaders;
import dreamengine.core.RenderPass;
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

class RenderShadows extends RenderPass {

	var lastStruct:VertexStructure;
	var structLength = 0;
	var pipelineState:PipelineState;

	function createPipelineState() {
		var pipelineState = new PipelineState();
		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		struct.add("uv", Float2);
		struct.add("vertexNormal", Float3);
		structLength = Std.int(struct.byteSize() / 4);

		pipelineState.inputLayout = [struct];

		pipelineState.vertexShader = kha.Shaders.shadowmap_vert;
		pipelineState.fragmentShader = Shaders.shadowmap_frag;
		pipelineState.cullMode = Clockwise;

		lastStruct = struct;
		pipelineState.depthWrite = true;
		pipelineState.depthMode = LessEqual;
		pipelineState.compile();

		this.pipelineState = pipelineState;
	}

	override function execute(renderer:Renderer) {
		createPipelineState();
		for (cam in renderer.cameras) {
			for (light in renderer.lights) {
                if (light is DirectionalLight == false) continue;
                var d:DirectionalLight = cast light;

				d.getRenderTarget().g2.begin();
				d.getRenderTarget().g2.drawRect(0, 0, 32, 32, 1);
				d.getRenderTarget().g2.end();
				var g4 = d.getRenderTarget().g4;
				g4.begin();
				g4.clear(Black, 1, 0);

				g4.setPipeline(pipelineState);

				updateLight(d, cam);

				for (rend in renderer.opaques) {
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

					var mvp:FastMatrix4 = FastMatrix4.identity();

                    switch(Type.getClass(light)){
                        case DirectionalLight:
                            var d:DirectionalLight = cast light;
                            mvp = d.getViewProjectionMatrix().multmat(rend.modelMatrix);
                            g4.setMatrix(pipelineState.getConstantLocation("lightSpaceMatrix"), d.getViewProjectionMatrix());
                    }

					g4.setMatrix(pipelineState.getConstantLocation("Model"), rend.modelMatrix);

					g4.drawIndexedVertices();
				}
                g4.end();
				cam.getRenderTarget().g2.begin(false);
				cam.getRenderTarget().g2.drawRect(0,400,200,200);
				cam.getRenderTarget().g2.drawScaledImage(d.getRenderTarget(), 0,400,200,200);
				cam.getRenderTarget().g2.end();
			}
		}
	}

	function updateLight(light:DirectionalLight, cam:Camera) {
		var camViewMatrix = cam.getViewMatrix();
		var cameraPos = new Vector3(camViewMatrix._30, camViewMatrix._31, camViewMatrix._32);

		//light.viewMatrix = FastMatrix4.lookAt(pos, pos + fw, up);

		light.viewProjectionMatrix = light.projectionMatrix.multmat(light.viewMatrix);

		ShaderGlobals.setMatrix("lightSpaceMatrix", light.viewProjectionMatrix);
	}
}
