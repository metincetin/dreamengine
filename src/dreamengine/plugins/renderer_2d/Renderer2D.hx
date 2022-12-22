package dreamengine.plugins.renderer_2d;

import dreamengine.plugins.renderer_2d.systems.ParticleRenderer2D.ParticleRenderer;
import kha.graphics4.PipelineState;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System.RenderContext;
import dreamengine.plugins.renderer_base.IRenderContextProvider;
import kha.Framebuffer;
import dreamengine.plugins.ecs.ECS;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.plugins.renderer_2d.systems.*;

class Renderer2D implements IPlugin implements IRenderContextProvider {
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

		ecs.registerRenderSystem(spriteRenderer);
		ecs.registerRenderSystem(new ParticleRenderer());
		ecs.registerSystem(new SpriteAnimationPlayer());

		ecs.registerRenderContextProvider(this);
	}

	public function finalize() {
		ecs.unregisterRenderSystem(spriteRenderer);
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

	public function getRenderContext(camera:Camera):RenderContext {
		return new RenderContext(engine, null, camera);
	}

	public function getRenderingBackend():RenderingBackend {
		return RenderingBackend.G2;
	}
}
