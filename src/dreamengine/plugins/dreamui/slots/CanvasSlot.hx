package dreamengine.plugins.dreamui.slots;

import kha.math.Vector2i;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.device.Screen;

class CanvasSlot extends BaseSlot {
	public var anchorsMin:Vector2 = Vector2.zero();
	public var anchorsMax:Vector2 = Vector2.zero();

	public var offset:Vector2 = Vector2.zero();
	public var sizeOffset:Vector2 = Vector2.zero();

	public function new(parent:Widget) {
		super(parent);
	}

	public override function getPosition():Vector2 {
		var parentPos:Vector2;
		var parentSize:Vector2;

		if (parent != null) {
			var parentSlot = parent.getSlot();
			parentPos = parentSlot.getPosition();
			parentSize = parentSlot.getSize();
		} else {
			parentPos = Vector2.zero();
			parentSize = Screen.getResolution().asVector2();
		}
		var pos = Vector2.zero();

		pos.x = parentPos.x + parentSize.x * anchorsMin.x + offset.x;
		pos.y = parentPos.y + parentSize.y * anchorsMin.y + offset.y;

		return pos;
	}

	public override function getSize() {
		var parentPos:Vector2;
		var parentSize:Vector2;

		if (parent != null) {
			var parentSlot = parent.getSlot();
			parentPos = parentSlot.getPosition();
			parentSize = parentSlot.getSize();
		} else {
			parentPos = Vector2.zero();
			parentSize = Screen.getResolution().asVector2();
		}

		var size = Vector2.zero();

		size.x = parentSize.x * anchorsMax.x + sizeOffset.x;
		size.y = parentSize.y * anchorsMax.y + sizeOffset.y;

		return size;
	}

	public function toFullRect() {
		anchorsMin = Vector2.zero();
		anchorsMax = Vector2.one();
	}

	public static function fullRect(p:Widget) {
		var ret = new CanvasSlot(p);
		ret.toFullRect();
		return ret;
	}
}
