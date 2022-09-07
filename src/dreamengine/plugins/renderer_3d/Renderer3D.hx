package dreamengine.plugins.renderer_3d;

import dreamengine.plugins.renderer_3d.systems.PointLightSystem;
import dreamengine.core.math.Quaternion;
import dreamengine.plugins.renderer_base.components.Camera;
import kha.Assets;
import dreamengine.plugins.renderer_3d.loaders.ObjLoader;
import kha.Color;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import dreamengine.plugins.renderer_3d.systems.DirectionalLightSystem;
import dreamengine.plugins.renderer_3d.systems.CameraRotator;
import dreamengine.plugins.renderer_base.systems.CameraSystem;
import dreamengine.plugins.renderer_base.ActiveCamera;
import dreamengine.plugins.renderer_3d.systems.Rotator;
import dreamengine.core.math.Vector.Vector3;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.renderer_base.IRenderContextProvider;
import dreamengine.plugins.renderer_3d.systems.MeshRenderer;
import kha.math.FastVector3;
import kha.graphics4.ConstantLocation;
import kha.math.FastMatrix4;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.PipelineState;
import kha.Framebuffer;
import dreamengine.plugins.ecs.ECS;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.plugins.ecs.System.RenderContext;

class Renderer3D implements IPlugin implements IRenderContextProvider {
	var ecs:ECS;
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipelineState:PipelineState;
	var vp:FastMatrix4;
	var viewMatrixID:kha.graphics4.ConstantLocation;
	var modelMatrixID:ConstantLocation;
	var lightID:ConstantLocation;
	var model:FastMatrix4;
	var view:FastMatrix4;
	var projection:FastMatrix4;
	var engine:Engine;

	public function new() {}

	public function initialize(engine:Engine) {
		initializeRenderer();
		this.engine = engine;
		var pluginResult = engine.pluginContainer.getPlugin("ecs");
		switch (pluginResult) {
			case Some(v):
				ecs = cast(v, ECS);
			case None:
				throw "Could not find ECS plugin";
		}

		var meshRenderer = new MeshRenderer();
		ecs.registerRenderSystem(meshRenderer);
		ecs.registerSystem(new DirectionalLightSystem());
		ecs.registerSystem(new PointLightSystem());
		ecs.registerSystem(new Rotator());
		ecs.registerSystem(new CameraSystem());
		ecs.registerSystem(new CameraRotator());
		ecs.registerRenderContextProvider(this);
		ecs.spawn([
			Transform.prs(Vector3.zero(), Quaternion.fromEuler(0, -90, 25), Vector3.one()),
			new DirectionalLight(Color.White, 1)
		]);
		ecs.spawn([
			Transform.prs(new Vector3(0, 0, -5), Quaternion.identity(), Vector3.one()),
			dreamengine.plugins.renderer_base.components.Camera.perspective(45, 4.0 / 3.0, new Vector2(0.01, 100))
		]);
	}

	function initializeRenderer() {
		pipelineState = new PipelineState();
	}

	public function finalize() {}

	public function getName():String {
		return "renderer_2d";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [ECS];
	}

	public function handleDependency(ofType:Class<IPlugin>) {
		switch (ofType) {
			case ECS:
				return new ECS();
		}
		return null;
	}

	public function getRenderContext(components:Array<Component>, framebuffer:Framebuffer, camera:Camera):RenderContext {
		return new RenderContext(components, engine, framebuffer, pipelineState, camera);
	}
}
