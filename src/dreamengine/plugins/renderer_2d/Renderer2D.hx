package dreamengine.plugins.renderer_2d;

import dreamengine.plugins.renderer_base.systems.CameraSystem;
import dreamengine.plugins.renderer_2d.systems.ParticleRenderer2D.ParticleRenderer;
import kha.graphics4.PipelineState;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.ecs.Component;
import kha.Framebuffer;
import dreamengine.plugins.ecs.ECS;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.plugins.renderer_2d.systems.*;

class Renderer2D implements IPlugin{
	var ecs:ECS;
	var engine:Engine;

	// systems
	var spriteRenderer = new SpriteRenderer();

	var pipelineState:PipelineState;

	public function new() {}

	public function initialize(engine:Engine) {
		this.pipelineState = new PipelineState();
		this.engine = engine;
		ecs = engine.pluginContainer.getPlugin(ECS);

		if (ecs == null) {
			throw "Could not find ECS plugin";
		}

		ecs.registerSystem(spriteRenderer);
		ecs.registerSystem(new LineRenderer2D());
		ecs.registerSystem(new ParticleRenderer());
		ecs.registerSystem(new CameraSystem());
		ecs.registerSystem(new SpriteAnimationPlayer());
		ecs.registerSystem(new CameraSystem());

	}

	public function finalize() {
	}

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

}
