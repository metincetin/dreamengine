package dreamengine.plugins.renderer_3d.passes;

import dreamengine.plugins.renderer_base.ShaderGlobals;
import dreamengine.plugins.renderer_base.components.Camera;
import kha.graphics5_.CubeMap;
import kha.Image;
import dreamengine.core.math.Vector3;
import kha.math.FastMatrix4;
import kha.graphics4.VertexStructure;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.PipelineState;
import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class RenderSkybox extends RenderPass {
	var pipeline:PipelineState;
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
    var modelMatrix: FastMatrix4;

	public function new() {
		super();
		pipeline = new PipelineState();
		pipeline.vertexShader = kha.Shaders.simple_vert;
		pipeline.fragmentShader = kha.Shaders.skybox_procedural_frag;
		pipeline.depthWrite = false;
		pipeline.depthMode = LessEqual;
		pipeline.cullMode = CounterClockwise;



		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		struct.add("uv", Float2);
		struct.add("vertexNormal", Float3);
		var structLength = Std.int(struct.byteSize() / 4);

		pipeline.inputLayout = [struct];

		pipeline.compile();

		var mesh = Primitives.sphereMesh;
		var positions = mesh.vertices;
		var normals = mesh.normals;
		var uvs = mesh.uvs;

		var vertNum = Std.int(positions.length / 3);

		vertexBuffer = new VertexBuffer(vertNum, struct, StaticUsage);

		var vbData = vertexBuffer.lock();

		for (i in 0...vertNum) {
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

		indexBuffer = new IndexBuffer(mesh.indices.length, StaticUsage);

		var iData = indexBuffer.lock();

		for (i in 0...iData.length) {
			iData[i] = mesh.indices[i];
		}

		indexBuffer.unlock();

	}

	override function execute(renderer:Renderer) {
		for (cam in renderer.cameras) {
			var g = cam.getRenderTarget().g4;
			g.begin();
			g.setPipeline(pipeline);
            g.setVertexBuffer(vertexBuffer);
            g.setIndexBuffer(indexBuffer);


            var camView = cam.getViewMatrix();
            var camPos = new Vector3(camView._30, camView._31, camView._32);
			var l = cam.clippingPlanes.y;
            modelMatrix = FastMatrix4.translation(camPos.x, camPos.y, camPos.z).multmat(FastMatrix4.scale(l,l, l));

            var mvp = cam.getViewProjectionMatrix().multmat(modelMatrix);
            g.setMatrix(pipeline.getConstantLocation("Model"), modelMatrix);
            g.setMatrix(pipeline.getConstantLocation("MVP"), mvp);
			ShaderGlobals.apply(pipeline, g);

			g.drawIndexedVertices();
			g.end();
		}
	}
}
