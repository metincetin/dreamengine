package dreamengine.plugins.ecs;

class ECSContext {
	var entities = new Array<Entity>();

	public function new() {}

	public function getEntities() {
		return entities;
	}

	public function query(params:Array<IQueryParam>) {
		var ret = new Array<FilterResult>();
		for (entity in entities) {
			var valid = true;
			var components = new Array<Component>();
			for (q in params) {
				if (q.test(entity)) {
					components.push(q.get(entity));
				} else {
					valid = false;
				}
			}

			if (valid) {
				ret.push(new FilterResult(components, entity));
			}
		}
		return ret;
	}

	public function filter(t:Array<Class<Component>>):Array<FilterResult> {
		var ret = new Array<FilterResult>();
		for (entity in entities) {
			var targets = t;
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
				ret.push(new FilterResult(components, entity));
			}
		}
		return ret;
	}

	public function addEntity(entity:Entity) {
		entities.push(entity);
	}

	public function removeEntity(entity:Entity) {
		entities.remove(entity);
	}
}

class FilterResult {
	var components = new Array<Component>();
	var entity:Entity;

	public function new(components:Array<Component>, entity:Entity) {
		this.components = components;
		this.entity = entity;
	}

	@:generic
	public function getComponent<T>(type:Class<T>):T {
		for (c in components) {
			if (Std.isOfType(c, type))
				return cast c;
		}
		return null;
	}

	public function markKill() {
		entity.queueKill();
	}
}

interface IQueryParam {
	public function test(entity:Entity):Bool;
	public function get(entity:Entity):Component;
}

class With<T:Class<Component>> implements IQueryParam {
	var type:T;

	public function new(type:T) {
		this.type = type;
	}

	public function test(entity:Entity):Bool {
		return entity.hasComponent(type);
	}

	public function get(entity:Entity):Component {
		return entity.getComponent(type);
	}
}

class Without<T:Class<Component>> implements IQueryParam {
	var type:T;

	public function new(type:T) {
		this.type = type;
	}

	public function test(entity:Entity):Bool {
		return !entity.hasComponent(type);
	}

	public function get(entity:Entity):Component {
		return null;
	}
}

class Optional<T:Class<Component>> implements IQueryParam {
	var type:T;

	public function new(type:T) {
		this.type = type;
	}

	public function test(entity:Entity):Bool {
		return true;
	}

	public function get(entity:Entity):Component {
		return entity.getComponent(type);
	}
}
