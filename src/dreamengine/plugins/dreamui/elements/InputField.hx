package dreamengine.plugins.dreamui.elements;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.dreamui.utils.TextRenderingUtils;
import dreamengine.plugins.input.events.KeyboardKeyEvent;
import dreamengine.plugins.input.devices.BaseKeyboard.KeyboardKey;
import dreamengine.plugins.dreamui.events.IInputTarget;
import dreamengine.core.math.Mathf;
import dreamengine.core.Time;
import kha.graphics2.Graphics;
import dreamengine.plugins.dreamui.events.*;
import dreamengine.plugins.dreamui.Element.Element;

class InputField extends Element implements IFocusable implements IPointerTarget implements IClickable implements IInputTarget {
	var text:String = "";
	var placeholder:String = "Enter text..";
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
		var pos = rect.getPosition();
		var size = rect.getSize();

		g2.font = kha.Assets.fonts.OpenSans_Regular;
		g2.color = kha.Color.Red;
		g2.fontSize = 14;
		g2.fillRect(pos.x, pos.y, size.x, size.y);

		g2.color = kha.Color.White;
		
		var prefSize = new Vector2(
			g2.font.width(g2.fontSize, text),
			g2.font.height(g2.fontSize)
		);
		var textPos = TextRenderingUtils.getAlignedPosition(rect, prefSize, MiddleLeft);

		if (text.length == 0 && !isFocused()) {
			g2.drawString(placeholder, textPos.x, textPos.y);
		} else {
			g2.drawString(text, textPos.x, textPos.y);
		}
		if (isFocused())
			renderBlink(g2, textPos, opacity);
	}

	function renderBlink(g2:Graphics, alignedPos:Vector2, opacity:Float) {
		var x = g2.font.width(g2.fontSize, text) + 4;
		var pos = alignedPos;
		var height = g2.font.height(g2.fontSize);
		var halfHeight = height * 0.5;
		var time = Time.getTime();
		var blink = (Mathf.sin(time * 8) + 1) * 0.5;

		g2.pushOpacity(opacity * blink);

		g2.drawLine(pos.x + x, pos.y + 2, pos.x + x, pos.y + height - 2, 2);

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
