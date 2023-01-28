package dreamengine.plugins.dreamui.elements;

import dreamengine.core.math.Mathf;
import dreamengine.plugins.dreamui.utils.LayoutUtils;
import dreamengine.plugins.dreamui.events.IClickable;
import dreamengine.plugins.dreamui.events.IFocusable;
import dreamengine.plugins.dreamui.events.IPointerTarget;
import dreamengine.core.math.Vector.Vector2;
import kha.graphics2.Graphics;

class Button extends Element implements IPointerTarget implements IClickable implements IFocusable {
	var text:String = "";

	var color:kha.Color = kha.Color.fromBytes(125, 125, 125);

	var onClicked:Array<Void->Void> = [];

	var prefSize = new Vector2();

	public function new(text:String = "") {
		super();
		this.text = text;
	}

	override function getPreferredSize():Vector2 {
		return prefSize;
	}

	override function onRender(g2:Graphics, opacity:Float) {
		var pos = rect.getPosition();
		var size = rect.getSize();
		
		size.x = Math.max(size.x, prefSize.x) + parsedStyle.getFloatValue("padding-left", 0) + parsedStyle.getFloatValue("padding-right", 0);
		size.y = Math.max(size.y, prefSize.y) + parsedStyle.getFloatValue("padding-top", 0) + parsedStyle.getFloatValue("padding-bottom", 0);


		var center = pos.copy();
		center.x += size.x * 0.5;
		center.y += size.y * 0.5;

		g2.color = parsedStyle.getColorValue("background-color", kha.Color.Cyan);
		g2.fontSize = parsedStyle.getIntValue("font-size", 12);

		var pivotOffset = LayoutUtils.getPivotOffset(this);


		var textSize = new Vector2();
		textSize.x = g2.font.width(g2.fontSize, text) * 0.5;
		textSize.y = g2.font.height(g2.fontSize) * 0.5;

		prefSize.x = textSize.x * 2;
		prefSize.y = textSize.y * 2;

		g2.fillRect(pos.x + pivotOffset.x, pos.y + pivotOffset.y, size.x, size.y);
		g2.color = parsedStyle.getColorValue("text-color");
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
