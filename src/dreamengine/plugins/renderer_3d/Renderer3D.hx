package dreamengine.plugins.renderer_3d;

import dreamengine.plugins.renderer_3d.passes.RenderShadows;
import dreamengine.plugins.renderer_3d.passes.RenderOpaques;
import dreamengine.plugins.renderer_3d.passes.RenderSkybox;
import dreamengine.plugins.renderer_base.systems.CameraSystem;
import dreamengine.plugins.renderer_3d.systems.PointLightSystem;
import dreamengine.core.math.Quaternion;
import dreamengine.plugins.renderer_base.components.Camera;
import kha.Assets;
import dreamengine.plugins.renderer_3d.loaders.ObjLoader;
import kha.Color;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import dreamengine.plugins.renderer_3d.systems.DirectionalLightSystem;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.ecs.Component;
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

class Renderer3D implements IPlugin{
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
		ecs = engine.pluginContainer.getPlugin(ECS);
		if (ecs == null) {
			throw "ECS is not found";
		}

		var meshRenderer = new MeshRenderer();
		ecs.registerSystem(meshRenderer);
		ecs.registerSystem(new DirectionalLightSystem());
		ecs.registerSystem(new CameraSystem());

        engine.getRenderer().pipeline.push(new RenderOpaques());
        engine.getRenderer().pipeline.push(new RenderShadows());
		engine.getRenderer().pipeline.push(new RenderSkybox());
	}

	function initializeRenderer() {
		pipelineState = new PipelineState();
	}

	public function finalize() {}

	public function getName():String {
		return "renderer_3d";
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
}
