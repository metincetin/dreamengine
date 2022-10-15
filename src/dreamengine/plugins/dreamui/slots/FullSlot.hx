package dreamengine.plugins.dreamui.slots;

import dreamengine.core.math.Vector.Vector2;

class FullSlot extends BaseSlot {
	override function getPosition():Vector2 {
		return getParent().getSlot().getPosition();
	}

	override function getSize():Vector2 {
		return getParent().getSlot().getSize();
	}
}
