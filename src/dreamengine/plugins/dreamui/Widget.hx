package dreamengine.plugins.dreamui;

import dreamengine.plugins.dreamui.slots.CanvasSlot;
import dreamengine.plugins.dreamui.slots.ScreenSlot;
import dreamengine.plugins.dreamui.slots.AbsoluteSlot;
import dreamengine.plugins.dreamui.slots.BaseSlot;
import dreamengine.core.math.Vector.Vector2;
import kha.graphics2.Graphics;

class Widget {
	public var name = "";

	public var parent:Widget;

	var children:Array<Widget> = new Array<Widget>();

	var isDirty = false;

	var slot:BaseSlot;

	var localScale:Vector2 = Vector2.one();

	public function getLocalScale() {
		return localScale;
	}

	public function getSlot() {
		if (slot == null) {
			slot = CanvasSlot.fullRect(null);
		}
		return slot;
	}

	public function setLocalScale(scale:Vector2) {
		localScale = scale;
		isDirty = true;
	}

	public function getScale() {
		if (parent == null) {
			return localScale;
		}
		return Vector2.multiplyV(localScale, parent.getScale());
	}

	public function new() {}

	public function getIsDirty() {
		return isDirty;
	}

	public final function render(g2:Graphics) {
		onRender(g2);
		for (c in children) {
			c.render(g2);
		}
	}

	function onRender(g2:Graphics) {}

	public function addChild(c:Widget) {
		if (children.contains(c))
			return;

		children.push(c);
		c.parent = c;
		if (!Std.isOfType(c.getSlot(), getChildSlotType())) {
			c.slot = createSlotForChild();
		} else {
			c.slot.setParent(this);
		}
		isDirty = true;
	}

	function setDirtyAllChildren() {
		isDirty = true;
		for (c in children) {
			c.setDirtyAllChildren();
		}
	}

	function getChildSlotType():Class<BaseSlot> {
		return AbsoluteSlot;
	}

	function createSlotForChild():BaseSlot {
		return new AbsoluteSlot(this);
	}
}
