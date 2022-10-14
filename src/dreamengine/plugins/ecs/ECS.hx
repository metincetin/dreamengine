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
import dreamengine.plugins.ecs.System.SystemContext;
import kha.graphics2.Graphics;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.device.Screen;

class ECS implements IPlugin {
	var entities = new Array<Entity>();
	var systems = new Array<System>();
	var renderSystems = new Array<RenderSystem>();
	var renderContextProviders = new Array<IRenderContextProvider>();

	public function new() {}

	var engine:Engine;

	var customTicks = new Map<String, CustomTick>();

	public function initialize(engine:Engine) {
		this.engine = engine;
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

	public function executeCustomTick(name:String, e:Array<Any>) {
		if (customTicks.exists(name)) {
			trace(entities.length);
			var tick = customTicks.get(name);
			for (system in tick.forSystems) {
				for (entity in entities) {
					var targets = system.getTargetComponents();
					trace('System: ${Type.getClassName(Type.getClass(system))} TargetComponents: ${targets}');
					var valid = true;
					var components = new Array<Component>();
					for (target in targets) {
						if (!entity.hasComponent(target)) {
							valid = false;
							break;
						} else {
							trace('pushing component ${Type.getClassName(target)}');
							components.push(entity.getComponent(target));
						}
					}
					if (valid) {
						var context = new SystemContext(components, engine);
						trace("Completed");
						tick.func(context, e);
					}
				}
			}
		}
	}

	function tickGame(engine) {
		for (system in systems) {
			for (entity in entities) {
				var targets = system.getTargetComponents();
				var valid = true;
				var components = new Array<Component>();
				for (target in targets) {
					if (!entity.hasComponent(target)) {
						valid = false;
						break;
					}
					components.push(entity.getComponent(target));
				}
				if (valid) {
					var context = new SystemContext(components, engine);
					system.execute(context);
				}
			}
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
					for (entity in entities) {
						var targets = renderSystem.getTargetComponents();
						var valid = true;
						var components = new Array<Component>();
						for (target in targets) {
							if (!entity.hasComponent(target)) {
								valid = false;
								break;
							}
							components.push(entity.getComponent(target));
						}
						if (valid) {
							var context = contextProvider.getRenderContext(components, framebuffer, cam);
							renderSystem.execute(context);
						}
					}
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
		entities.push(entity);
		entity.onSpawned();
		return null;
	}

	public function despawn(entity:Entity) {
		entities.remove(entity);
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
