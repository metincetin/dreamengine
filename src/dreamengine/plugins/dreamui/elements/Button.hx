package dreamengine.plugins.dreamui.elements;

import dreamengine.plugins.dreamui.events.IClickable;
import dreamengine.plugins.dreamui.events.IFocusable;
import dreamengine.plugins.dreamui.events.IPointerTarget;
import dreamengine.core.math.Vector.Vector2;
import kha.graphics2.Graphics;

class Button extends Element implements IPointerTarget implements IClickable implements IFocusable {
	var text:String = "";

	var color:kha.Color = kha.Color.fromBytes(125, 125, 125);

	var onClicked:Array<Void->Void> = [];

	public function new(text:String = "") {
		super();
		this.text = text;
	}

	override function onRender(g2:Graphics, opacity:Float) {
		var pos = rect.position;
		var size = rect.size;
		var center = pos.copy();
		center.x += size.x * 0.5;
		center.y += size.y * 0.5;

		g2.color = color;

		var textSize = new Vector2();
		textSize.x = g2.font.width(g2.fontSize, text) * 0.5;
		textSize.y = g2.font.height(g2.fontSize) * 0.5;
		g2.fillRect(pos.x, pos.y, size.x, size.y);
		g2.color = kha.Color.White;
		g2.drawString(text, center.x - textSize.x, center.y - textSize.y);
	}

	public function canBeTargeted():Bool {
		return true;
	}

	public function onPointerEntered() {
		color = kha.Color.fromBytes(140, 140, 140);
	}

	public function onPointerExited() {
		color = kha.Color.fromBytes(125, 125, 125);
	}

	public function canBeFocused():Bool {
		return true;
	}

	public function onFocused() {}

	public function onFocusLost() {}

	public function isFocused():Bool {
		return true;
	}

	public function onPressed() {
		color = kha.Color.fromBytes(90, 90, 90);
	}

	public function onReleased() {
		color = kha.Color.fromBytes(140, 140, 140);
		invokeOnClicked();
	}

	function invokeOnClicked() {
		for (f in onClicked) {
			f();
		}
	}

	public function registerClickedEvent(f:Void->Void) {
		onClicked.push(f);
	}

	public function unregisterClickedEvent(f:Void->Void) {
		onClicked.remove(f);
	}
}
