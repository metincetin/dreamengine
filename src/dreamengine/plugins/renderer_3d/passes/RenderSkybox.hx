package dreamengine.plugins.renderer_3d.passes;

import js.html.idb.VersionChangeEvent;
import kha.CanvasImage;
import kha.math.FastVector2;
import dreamengine.device.Screen;
import kha.graphics4.ConstantLocation;
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
	var screenResolutionLocation:ConstantLocation;
	var projectionLocation:ConstantLocation;
	var viewLocation:ConstantLocation;



	public function new() {
		super();
		pipeline = new PipelineState();
		pipeline.vertexShader = kha.Shaders.skybox_vert;
		pipeline.fragmentShader = kha.Shaders.skybox_procedural_frag;
		pipeline.depthWrite = false;
		pipeline.depthMode = LessEqual;
		pipeline.cullMode = CounterClockwise;

		environment = CubeMap.createRenderTarget(256);

		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		struct.add("uv", Float2);
		struct.add("vertexNormal", Float3);
		var structLength = Std.int(struct.byteSize() / 4);

		pipeline.inputLayout = [struct];
		

		pipeline.compile();

		var mesh = Primitives.sphereMesh;
		vertexBuffer = mesh.getVertexBuffer();
		indexBuffer = mesh.getIndexBuffer();

		screenResolutionLocation = pipeline.getConstantLocation("resolution");
		viewLocation = pipeline.getConstantLocation("ViewMatrix");
		projectionLocation = pipeline.getConstantLocation("ProjectionMatrix");
		//cameraPosLocation = pipeline.getConstantLocation("cameraPosition");
	}

	function drawSkybox(g:Graphics, view:FastMatrix4, projection:FastMatrix4, clipping:Vector2){
			g.setPipeline(pipeline);
            g.setVertexBuffer(vertexBuffer);
            g.setIndexBuffer(indexBuffer);


            var camView = new FastMatrix4(
				view._00, view._10,view._20, view._30, view._01, view._11, view._21, view._31, view._02, view._12, view._22, view._32, view._03, view._13, view._23, view._33
			);
			camView._30 = 0;
			camView._31 = 0;
			camView._32 = 0;

			var l = clipping.y;

            //g.setMatrix(modelLocation, modelMatrix);
            g.setMatrix(viewLocation, view);
            g.setMatrix(projectionLocation, projection);

			var res = Screen.getResolution();
			g.setVector2(screenResolutionLocation, new FastVector2(res.x, res.y));
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
					var p = FastMatrix4.perspectiveProjection(45, 1, cam.clippingPlanes.x , cam.clippingPlanes.y);
					var v = FastMatrix4.lookAt(Vector3.zero(), skyboxFaces[i], Vector3.up());

					var vp = p.multmat(v);

					//drawSkybox(environment.g4, v, vp, cam.clippingPlanes);
					drawSkybox(environment.g4, cam.getViewMatrix(), cam.getProjectionMatrix(), cam.clippingPlanes);
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
