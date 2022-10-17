package dreamengine.plugins.ecs;

import kha.Color;
import dreamengine.plugins.renderer_base.ActiveCamera;
import kha.Framebuffer;
import dreamengine.plugins.renderer_base.IRenderContextProvider;
import dreamengine.plugins.ecs.System.RenderContext;
import dreamengine.plugins.ecs.System.RenderSystem;
import haxe.macro.Expr;
import haxe.ds.Map;
import haxe.Constraints.Function;
import kha.graphics2.Graphics;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.device.Screen;

class ECS implements IPlugin {
	var systems = new Array<System>();
	var renderSystems = new Array<RenderSystem>();
	var renderContextProviders = new Array<IRenderContextProvider>();

	var ecsContext = new ECSContext();

	public function new() {}

	var engine:Engine;

	var customTicks = new Map<String, CustomTick>();

	public function initialize(engine:Engine) {
		this.engine = engine;
		ecsContext = new ECSContext();

		engine.registerLoopEvent(tickGame);
		engine.registerRenderEvent(tickRender);
	}

	public function finalize() {
		engine.unregisterLoopEvent(tickGame);
		engine.unregisterRenderEvent(tickRender);
	}

	public function registerRenderContextProvider(provider:IRenderContextProvider) {
		renderContextProviders.push(provider);
	}

	public function registerCustomTick(name:String, systems:Array<System>, f:Function) {
		customTicks.set(name, new CustomTick(systems, f));
	}

	public function unregisterCustomTick(name:String, f:Function) {
		customTicks.remove(name);
	}

	function tickGame(engine) {
		for (system in systems) {
			system.execute(ecsContext);
		}
		killPendingEntities();
	}

	function killPendingEntities() {
		var pendingKill = new Array<Entity>();

		for (entity in ecsContext.getEntities()) {
			if (entity.isPendingKill()) {
				pendingKill.push(entity);
			}
		}
		for (entity in pendingKill) {
			despawn(entity);
		}
		while (pendingKill.length > 0) {
			pendingKill.pop();
		}
	}

	function tickRender(framebuffer:Framebuffer) {
		for (contextProvider in renderContextProviders) {
			for (i in 0...ActiveCamera.getCameraCount()) {
				var cam = ActiveCamera.getCamera(i);

				switch (contextProvider.getRenderingBackend()) {
					case G4:
						cam.renderTexture.g4.begin();
						cam.renderTexture.g4.clear(Transparent, 8);
						break;
					case G2:
						cam.renderTexture.g2.begin();
					case G1:
						cam.renderTexture.g1.begin();
				}

				for (renderSystem in renderSystems) {
					renderSystem.execute(ecsContext, contextProvider.getRenderContext(cam));
				}

				switch (contextProvider.getRenderingBackend()) {
					case G4:
						cam.renderTexture.g4.end();
						break;
					case G2:
						cam.renderTexture.g2.end();
					case G1:
						cam.renderTexture.g1.end();
				}
			}
		}
		framebuffer.g2.begin(false);
		for (i in 0...ActiveCamera.getCameraCount()) {
			var cam = ActiveCamera.getCamera(i);
			framebuffer.g2.clear(Color.Blue);
			var res = Screen.getResolution();
			framebuffer.g2.drawScaledImage(cam.renderTexture, 0, 0, res.x, res.y);
		}
		framebuffer.g2.end();
	}

	public function spawn(params:Array<Component>) {
		var entity = new Entity();
		for (comp in params) {
			entity.addComponent(comp);
		}
		ecsContext.addEntity(entity);
		entity.onSpawned();
		return entity;
	}

	public function despawn(entity:Entity) {
		ecsContext.removeEntity(entity);
		entity.onDespawned();
	}

	public function registerSystem(system:System) {
		systems.push(system);
		system.onRegistered(engine);
	}

	public function unregisterSystem(system:System) {
		systems.remove(system);
		system.onUnregistered(engine);
	}

	public function registerRenderSystem(system:RenderSystem) {
		renderSystems.push(system);
	}

	public function unregisterRenderSystem(system:RenderSystem) {
		renderSystems.remove(system);
	}

	public function getName():String {
		return "ecs";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>) {
		return null;
	}
}

class CustomTick {
	public var forSystems:Array<System>;
	public var func:Function;

	public function new(systems:Array<System>, func:Function) {
		forSystems = systems;
		this.func = func;
	}
}
