package dreamengine.plugins.renderer_3d.passes;

import kha.math.FastVector3;
import dreamengine.core.math.Vector2;
import kha.graphics4.Graphics;
import kha.graphics4.FragmentShader;
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

	var skyboxFaces = [Vector3.right(), Vector3.up(), Vector3.forward(), Vector3.left(), Vector3.down(), Vector3.back()];


	// todo: def not good here
	var environment:kha.graphics4.CubeMap;

	public function new() {
		super();
		pipeline = new PipelineState();
		pipeline.vertexShader = kha.Shaders.simple_vert;
		pipeline.fragmentShader = kha.Shaders.skybox_procedural_frag;
		pipeline.depthWrite = false;
		pipeline.depthMode = LessEqual;
		pipeline.cullMode = CounterClockwise;

		environment = CubeMap.createRenderTarget(1024);




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

	function drawSkybox(g:Graphics, view:FastMatrix4, viewProjection:FastMatrix4, clipping:Vector2){
			g.setPipeline(pipeline);
            g.setVertexBuffer(vertexBuffer);
            g.setIndexBuffer(indexBuffer);


            var camView = view;
            var camPos = new Vector3(camView._30, camView._31, camView._32);
			var l = clipping.y;
            var modelMatrix = FastMatrix4.translation(camPos.x, camPos.y, camPos.z).multmat(FastMatrix4.scale(l,l, l));

            var mvp = viewProjection.multmat(modelMatrix);
            g.setMatrix(pipeline.getConstantLocation("Model"), modelMatrix);
            g.setMatrix(pipeline.getConstantLocation("MVP"), mvp);
			ShaderGlobals.apply(pipeline, g);

			g.drawIndexedVertices();
	}

	override function execute(renderer:Renderer) {
		var bakedEnvironment = false;
		for (cam in renderer.cameras) {
			var g = cam.getRenderTarget().g4;
			g.begin();
			drawSkybox(g, cam.getViewMatrix(), cam.getViewProjectionMatrix(), cam.clippingPlanes);
			g.end();

			if (!bakedEnvironment){
				for(i in 0...6){
					environment.g4.beginFace(i);
					environment.g4.clear(null);
					var p = FastMatrix4.perspectiveProjection(45, 1, cam.clippingPlanes.x, cam.clippingPlanes.y);
					var v = FastMatrix4.lookAt(Vector3.zero(), skyboxFaces[i], Vector3.up());

					var vp = p.multmat(v);

					//drawSkybox(environment.g4, v, vp, cam.clippingPlanes);
					drawSkybox(environment.g4, cam.getViewMatrix(), cam.getViewProjectionMatrix(), cam.clippingPlanes);
					environment.g4.end();

				}
				ShaderGlobals.setCubemap("environmentMap", environment);
				bakedEnvironment = true;
			}

			var g2 = cam.getRenderTarget().g2;
			g2.begin(false);
			g2.end();
		}
	}
}
