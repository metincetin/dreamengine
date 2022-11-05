package dreamengine.plugins.dreamui;

import dreamengine.core.math.Rect;
import dreamengine.plugins.dreamui.slots.CanvasSlot;
import dreamengine.plugins.dreamui.slots.ScreenSlot;
import dreamengine.plugins.dreamui.slots.AbsoluteSlot;
import dreamengine.plugins.dreamui.slots.BaseSlot;
import dreamengine.core.math.Vector.Vector2;
import kha.graphics2.Graphics;

class Element {
	public var name = "";

	public var parent:Element;

	var children:Array<Element> = new Array<Element>();

	var isDirty = false;

	var slot:BaseSlot;

	var localScale:Vector2 = Vector2.one();

	var enabled:Bool = true;

	var renderOpacity:Float = 1;

	public function getEnabled() {
		return enabled;
	}

	public function setEnabled(value:Bool) {
		enabled = value;
		for (c in children) {
			c.setEnabled(value);
		}
	}

	public function setRenderOpacity(renderOpacity:Float) {
		this.renderOpacity = renderOpacity;
	}

	public function getRenderOpacity() {
		return this.renderOpacity;
	}

	public function getLocalScale() {
		return localScale;
	}

	public function getSlot() {
		if (slot == null) {
			slot = CanvasSlot.fullRect(null);
		}
		return slot;
	}

	@:generic
	public function getSlotAs<T>(type:Class<T>):T {
		return cast slot;
	}

	public function getChild(index:Int) {
		return children[index];
	}

	public function getChildren() {
		return children;
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

	public final function render(g2:Graphics, opacity:Float) {
		if (!getEnabled())
			return;
		g2.opacity = opacity * renderOpacity;
		onRender(g2, opacity);
		for (c in children) {
			c.render(g2, renderOpacity);
		}
		g2.opacity = 1;
	}

	function onRender(g2:Graphics, opacity:Float) {}

	public function addChild(c:Element, withSlot:BaseSlot = null) {
		if (children.contains(c))
			return;

		children.push(c);
		c.parent = c;
		if (withSlot != null) {
			c.slot = withSlot;
		} else {
			if (!Std.isOfType(c.getSlot(), getChildSlotType())) {
				c.slot = createSlotForChild(getChildCount() - 1);
			} else {
				c.slot.setParent(this);
			}
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

	function createSlotForChild(childIndex:Int):BaseSlot {
		return new AbsoluteSlot(this, childIndex);
	}

	public function getRect() {
		if (!enabled)
			return Rect.zero();
		var slot = getSlot();
		if (slot == null)
			return Rect.zero();

		return Rect.fromVectors(slot.getPosition(), slot.getSize());
	}

	public inline function getChildCount() {
		return children.length;
	}

	public function getPreferredSize(): Vector2{
		return Vector2.zero();
	}

	public function getSize(){
		return slot.getSize();
	}
	public function getPosition(){
		return slot.getPosition();
	}
}
