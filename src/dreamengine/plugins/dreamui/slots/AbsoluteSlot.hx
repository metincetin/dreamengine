package dreamengine.plugins.dreamui.slots;

import dreamengine.core.math.Vector.Vector2;

class AbsoluteSlot extends BaseSlot {
	public var position = Vector2.zero();
	public var size = Vector2.zero();

	public function new(p:Widget) {
		super(p);
	}

	public override function getPosition() {
		return position;
	}

	public override function getSize() {
		return size;
	}
}
