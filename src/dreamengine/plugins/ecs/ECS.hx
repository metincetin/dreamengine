package dreamengine.plugins.ecs;

import dreamengine.core.Time;
import dreamengine.debugging.Profiler;
import dreamengine.plugins.renderer_3d.Renderer3D;
import dreamengine.plugins.renderer_3d.systems.ShadowMapperSystem;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import kha.Scaler;
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

	function tickGame() {
		for (system in systems) {
			system.execute(ecsContext);
		}
		killPendingEntities();
		spawnQueued();
	}

	function spawnQueued() {
		for (components in ecsContext.getSpawnQueue()) {
			spawn(components);
		}
		ecsContext.clearSpawnQueue();
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
		Profiler.begin("ECS/Renderer");
		for (contextProvider in renderContextProviders) {
			var ctxProviderSampleName = 'ECS/Renderer/${Type.getClassName(Type.getClass(contextProvider))}';
			Profiler.begin(ctxProviderSampleName);
			for (i in 0...ActiveView.getViewCount()) {
				var view = ActiveView.getView(i);
				if (view.shouldDrawToContext(contextProvider) == false)
					continue;

				Profiler.begin('ECS/Renderer/${Type.getClassName(Type.getClass(view))}');
				switch (contextProvider.getRenderingBackend()) {
					case G4:
						view.getRenderTarget().g4.begin();
						view.getRenderTarget().g4.clear(Black, 16);
					// view.getRenderTarget().g4.clear(Black, 8);
					case G2:
						view.getRenderTarget().g2.begin();
					case G1:
						view.getRenderTarget().g1.begin();
				}

				for (renderSystem in renderSystems) {
					Profiler.begin('ECS/Renderer/${Type.getClassName(Type.getClass(view))}/${Type.getClassName(Type.getClass(renderSystem))}');
					renderSystem.execute(ecsContext, contextProvider.getRenderContext(view));
					Profiler.end('ECS/Renderer/${Type.getClassName(Type.getClass(view))}/${Type.getClassName(Type.getClass(renderSystem))}');
				}

				switch (contextProvider.getRenderingBackend()) {
					case G4:
						view.getRenderTarget().g4.end();
					// break;
					case G2:
						view.getRenderTarget().g2.end();
					case G1:
						view.getRenderTarget().g1.end();
				}
				Profiler.end('ECS/Renderer/${Type.getClassName(Type.getClass(view))}');
			}

			Profiler.end(ctxProviderSampleName);
		}
		framebuffer.g2.begin(false);
		for (i in 0...ActiveView.getViewCount()) {
			var view = ActiveView.getView(i);
			if (!view.shouldRenderToFramebuffer())
				continue;
			// framebuffer.g2.clear(Color.Blue);
			// var res = Screen.getResolution();
			Scaler.scale(view.getRenderTarget(), framebuffer, kha.System.screenRotation);
			// framebuffer.g2.drawScaledImage(cam.renderTexture, 0, 0, res.x, res.y);
		}
		framebuffer.g2.end();
		Profiler.end("ECS/Renderer");

		//trace(Profiler.getJSON());
	}

	public function spawn(params:Array<Component>) {
		var entity = new Entity();
		entity.addComponents(params);
		ecsContext.addEntity(entity);
		entity.onSpawned();
		return entity;
	}

	public function spawnTemplate(template:kha.Blob) {
		var str = template.toString();
		var entity = new Entity();
		var xml = Xml.parse(str).firstElement();
		for (i in xml.elementsNamed("Component")) {
			if (i.exists("type")) {
				var type = i.get("type");
				var cl = Type.resolveClass(type);
				if (cl == null) {
					trace("Component with given type is not found (" + type + ")");
					continue;
				}
				var inst = Type.createInstance(cl, []);
				for (field in Reflect.fields(inst)) {
					var elm = i.elementsNamed(field);
					for (e in elm) {
						trace(e.firstChild());
						Reflect.setField(inst, field, e.firstChild().toString());
					}
				}

				entity.addComponent(inst);
			}
		}
		ecsContext.addEntity(entity);
		entity.onSpawned();
		return entity;
	}

	function resolveType(inst:Component, node:Xml) {}

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
