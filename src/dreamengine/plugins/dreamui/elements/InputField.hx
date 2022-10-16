package dreamengine.plugins.dreamui.elements;

import dreamengine.plugins.input.events.KeyboardKeyEvent;
import dreamengine.plugins.input.devices.BaseKeyboard.KeyboardKey;
import dreamengine.plugins.dreamui.events.IInputTarget;
import kha.math.Vector2;
import dreamengine.core.math.Mathf;
import dreamengine.core.Time;
import kha.graphics2.Graphics;
import dreamengine.plugins.dreamui.events.*;
import dreamengine.plugins.dreamui.Element.Element;

class InputField extends Element implements IFocusable implements IPointerTarget implements IClickable implements IInputTarget {
	var text:String = "";

	var focused = false;

	public function new() {
		super();
	}

	public function getText() {
		return text;
	}

	public function setText(text:String) {
		this.text = text;
	}

	public function canBeFocused():Bool {
		return true;
	}

	public function onFocused() {
		focused = true;
	}

	public function onFocusLost() {
		focused = false;
	}

	public function isFocused():Bool {
		return focused;
	}

	public function canBeTargeted():Bool {
		return true;
	}

	public function onPointerEntered() {}

	public function onPointerExited() {}

	public function onPressed() {}

	public function onReleased() {}

	override function onRender(g2:Graphics, opacity:Float) {
		var rect = getRect();

		g2.font = kha.Assets.fonts.arial;
		g2.color = kha.Color.Black;

		g2.fillRect(rect.position.x, rect.position.y, rect.size.x, rect.size.y);

		g2.color = kha.Color.White;

		g2.drawString(text, rect.position.x, rect.position.y + g2.font.height(g2.fontSize) * 0.5);

		if (isFocused())
			renderBlink(g2, opacity);
	}

	function renderBlink(g2:Graphics, opacity:Float) {
		var offset = new Vector2(1, 3);
		var x = g2.font.width(g2.fontSize, text) + 4;
		var pos = getSlot().getPosition();
		var height = getSlot().getSize().y;

		var time = Time.getTime();
		var blink = (Mathf.sin(time * 8) + 1) * 0.5;

		// g2.pushOpacity(opacity);

		g2.pushOpacity(opacity * blink);

		g2.drawLine(pos.x + x + offset.x, pos.y + offset.y, pos.x + x + offset.x, pos.y + height - offset.y, 2);

		g2.popOpacity();
	}

	public function allowInput():Bool {
		return focused;
	}

	public function onInputReceived(key:KeyboardKeyEvent) {
		if (key.isBackspace() && text.length != 0) {
			text = text.substr(0, text.length - 1);
			return;
		}
		text += (key.toString());
	}
}
