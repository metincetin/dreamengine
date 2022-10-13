package dreamengine.plugins.renderer_2d;

import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System.RenderContext;
import dreamengine.plugins.renderer_base.IRenderContextProvider;
import dreamengine.plugins.ecs.System.SystemContext;
import kha.Framebuffer;
import dreamengine.plugins.renderer_2d.components.Camera;
import dreamengine.plugins.ecs.ECS;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.plugins.renderer_2d.systems.*;

class Renderer2D implements IPlugin implements IRenderContextProvider {
	var ecs:ECS;
	var engine:Engine;

	// systems
	var spriteRenderer = new SpriteRenderer();
	var currentCamera:Camera;

	public function new() {}

	public function getCamera() {
		return currentCamera;
	}

	public function setCamera(value:Camera) {
		currentCamera = value;
	}

	public function initialize(engine:Engine) {
		this.engine = engine;
		ecs = engine.pluginContainer.getPlugin(ECS);

		if (ecs == null) {
			throw "Could not find ECS plugin";
		}

		engine.registerRenderEvent(onRender);
		ecs.registerRenderSystem(spriteRenderer);
		ecs.registerSystem(new SpriteAnimationPlayer());

		ecs.registerRenderContextProvider(this);
	}

	function onRender(frameBuffer:Framebuffer) {
		var g2 = frameBuffer.g2;

		g2.begin(true, kha.Color.Black);
		if (getCamera() != null)
			getCamera().apply(g2);

		ecs.executeCustomTick("renderer_2d", [g2, getCamera()]);

		if (getCamera() != null)
			getCamera().revert(g2);
		g2.end();
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

	public function getRenderContext(components:Array<Component>, framebuffer:Framebuffer,
			camera:dreamengine.plugins.renderer_base.components.Camera):RenderContext {
		return new RenderContext(components, engine, framebuffer, null, camera);
	}
}
