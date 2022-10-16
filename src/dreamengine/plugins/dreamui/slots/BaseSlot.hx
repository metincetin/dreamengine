package dreamengine.plugins.dreamui.slots;

import dreamengine.core.math.Vector.Vector2;

class BaseSlot {
	var parent:Element;

	public function new(parent:Element) {
		this.parent = parent;
	}

	public function getParent() {
		return parent;
	}

	public function setParent(p:Element) {
		this.parent = p;
	}

	public function getSize():Vector2 {
		return new Vector2(100, 100);
	}

	public function getPosition():Vector2 {
		return new Vector2(0, 0);
	}
}
