package dreamengine.plugins.renderer_2d;

import dreamengine.plugins.ecs.System.SystemContext;
import kha.Framebuffer;
import dreamengine.plugins.renderer_2d.components.Camera;
import dreamengine.plugins.ecs.ECS;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.plugins.renderer_2d.systems.*;

class Renderer2D implements IPlugin {
	var ecs:ECS;

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
		var pluginResult = engine.pluginContainer.getPlugin("ecs");
		switch (pluginResult) {
			case Some(v):
				ecs = cast(v, ECS);
			case None:
				throw "Could not find ECS plugin";
		}

		engine.registerRenderEvent(onRender);

		ecs.registerSystem(spriteRenderer);
		ecs.registerCustomTick("renderer_2d", [spriteRenderer], onSystemRenderRequested);

		ecs.registerSystem(new SpriteAnimationPlayer());
	}

	function onSystemRenderRequested(ctx:SystemContext, args:Array<Any>) {
		spriteRenderer.render(ctx, args);
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
		ecs.unregisterSystem(spriteRenderer);
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
