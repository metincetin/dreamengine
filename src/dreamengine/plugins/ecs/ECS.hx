package dreamengine.plugins.ecs;

import dreamengine.core.Time;
import dreamengine.debugging.Profiler;
import dreamengine.plugins.renderer_3d.Renderer3D;
import dreamengine.plugins.renderer_3d.systems.ShadowMapperSystem;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import kha.Scaler;
import kha.Color;
import kha.Framebuffer;
import haxe.macro.Expr;
import haxe.ds.Map;
import haxe.Constraints.Function;
import kha.graphics2.Graphics;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.device.Screen;

class ECS implements IPlugin {
	var systems = new Array<System>();

	var ecsContext = new ECSContext();

	public function new() {}

	var engine:Engine;

	public function initialize(engine:Engine) {
		this.engine = engine;
		ecsContext = new ECSContext();

		engine.registerLoopEvent(tickGame);
	}

	public function finalize() {
		engine.unregisterLoopEvent(tickGame);
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
