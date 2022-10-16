package dreamengine.plugins.ecs;

class Entity {
	public var components = new Array<Component>();

	public function new() {}

	public function addComponent(component:Component) {
		components.push(component);
		component.onAdded(this);
	}

	public function removeComponent(component:Component) {
		if (components.remove(component)) {
			component.onRemoved(this);
		}
	}

	public function getComponent<T>(type:Class<T>):T {
		for (comp in components) {
			if (Std.isOfType(comp, type)) {
				return cast comp;
			}
		}
		return null;
	}

	public function hasComponent(type:Class<Component>) {
		for (comp in components) {
			if (Std.isOfType(comp, type)) {
				return true;
			}
		}
		return false;
	}

	public function onSpawned() {}

	public function onDespawned() {}
}
