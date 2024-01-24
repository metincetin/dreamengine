package dreamengine.plugins.renderer_3d.passes;

import dreamengine.core.math.Mathf;
import kha.Assets;
import dreamengine.plugins.renderer_3d.loaders.ObjLoader;
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


	var shadowMap:Image;



	public function new() {
		super();



		pipeline = new PipelineState();
		pipeline.vertexShader = kha.Shaders.skybox_vert;
		pipeline.fragmentShader = kha.Shaders.skybox_procedural_frag;
		pipeline.depthWrite = false;
		pipeline.depthMode = LessEqual;
		pipeline.cullMode = None;

		environment = CubeMap.createRenderTarget(256);

		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		struct.add("uv", Float2);
		struct.add("vertexNormal", Float3);
		var structLength = Std.int(struct.byteSize() / 4);

		pipeline.inputLayout = [struct];
		

		pipeline.compile();

		var mesh = ObjLoader.load(Assets.blobs.engine_primitive_skybox_obj);
		vertexBuffer = mesh.getVertexBuffer();
		indexBuffer = mesh.getIndexBuffer();

		screenResolutionLocation = pipeline.getConstantLocation("resolution");
		viewLocation = pipeline.getConstantLocation("ViewMatrix");
		projectionLocation = pipeline.getConstantLocation("ProjectionMatrix");
		//cameraPosLocation = pipeline.getConstantLocation("cameraPosition");
	}

	function drawSkybox(g:Graphics, view:FastMatrix4, projection:FastMatrix4, clipping:Vector2){
			g.setPipeline(pipeline);

            g.setMatrix(viewLocation, view);
            g.setMatrix(projectionLocation, projection);

			var res = Screen.getResolution();
			g.setVector2(screenResolutionLocation, new FastVector2(res.x, res.y));
			ShaderGlobals.apply(pipeline, g);

            g.setVertexBuffer(vertexBuffer);
            g.setIndexBuffer(indexBuffer);
			g.drawIndexedVertices();
	}

	override function execute(renderer:Renderer) {
		if (EnvironmentSettings.active.skybox == None) return;
		var bakedEnvironment = false;
		for (cam in renderer.cameras) {
			var g = cam.getRenderTarget().g4;
			g.begin();
			var v = cam.getViewMatrix();
			v._30 = 0;
			v._31 = 0;
			v._32 = 0;

			drawSkybox(g, v, cam.getProjectionMatrix(), cam.clippingPlanes);
			g.end();

			if (!bakedEnvironment){
				for(i in 0...6){
					environment.g4.beginFace(i);
					environment.g4.clear(null);
					var p = FastMatrix4.perspectiveProjection(Mathf.degToRad(45), 1, cam.clippingPlanes.x , cam.clippingPlanes.y);
					var v = FastMatrix4.lookAt(Vector3.zero(), skyboxFaces[i], Vector3.up());

					var vp = p.multmat(v);

					//drawSkybox(environment.g4, v, vp, cam.clippingPlanes);
					drawSkybox(environment.g4, cam.getViewMatrix(), cam.getProjectionMatrix(), cam.clippingPlanes);
					environment.g4.end();

				}
				ShaderGlobals.setCubemap("_EnvironmentMap", environment);

				bakedEnvironment = true;
			}

			var g2 = cam.getRenderTarget().g2;
			g2.begin(false);
			g2.end();
		}
	}
}
