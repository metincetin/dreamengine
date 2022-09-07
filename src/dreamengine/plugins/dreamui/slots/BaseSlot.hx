package dreamengine.plugins.dreamui.slots;

import dreamengine.core.math.Vector.Vector2;

class BaseSlot {
	var parent:Widget;

	public function new(parent:Widget) {
		this.parent = parent;
	}

	public function getParent() {
		return parent;
	}

	public function setParent(p:Widget) {
		this.parent = p;
	}

	public function getSize():Vector2 {
		return new Vector2(100, 100);
	}

	public function getPosition():Vector2 {
		return new Vector2(0, 0);
	}
}
