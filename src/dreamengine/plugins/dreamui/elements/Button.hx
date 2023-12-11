package dreamengine.plugins.dreamui.elements;

import dreamengine.plugins.dreamui.events.PointerEventData;
import js.html.PointerEvent;
import kha.Font;
import kha.Assets;
import dreamengine.core.math.Mathf;
import dreamengine.plugins.dreamui.utils.LayoutUtils;
import dreamengine.plugins.dreamui.events.IClickable;
import dreamengine.plugins.dreamui.events.IFocusable;
import dreamengine.plugins.dreamui.events.IPointerTarget;
import dreamengine.core.math.Vector2;
import kha.graphics2.Graphics;

class Button extends Element implements IPointerTarget implements IClickable implements IFocusable {
	var text:String = "";

	var onClicked:Array<Void->Void> = [];


	var font:Font;
	var fontSize:Int = 12;
	var padding:Dimension;


	public function new(text:String = "") {
		super();
		this.text = text;
	}

	public function getText(){ return text; }
	public function setText(value:String){ text = value; }

	override function getPreferredSize():Vector2 {
		var prefSize = new Vector2();

		var textSize = new Vector2();
		textSize.x = font.width(fontSize, text) * 0.5;
		textSize.y = font.height(fontSize) * 0.5;
		
		prefSize.y = textSize.y * 2 + (padding.top + padding.bottom);
		prefSize.x = textSize.x * 2 + (padding.top + padding.bottom);
		return prefSize;
	}

	override function parseStyle() {
		super.parseStyle();
		padding = new Dimension(
			parsedStyle.getFloatValue("padding-left", 0),
			parsedStyle.getFloatValue("padding-top", 0),
			parsedStyle.getFloatValue("padding-right", 0),
			parsedStyle.getFloatValue("padding-bottom", 0));
		
		font = Assets.fonts.get(parsedStyle.getStringValue("font", "OpenSans_Regular"));
		fontSize = parsedStyle.getIntValue("font-size", 12);
	}

	override function onRender(g2:Graphics, opacity:Float) {
		var size = rect.getSize();
		var pos = rect.getPosition();
		
		padding = new Dimension(
			parsedStyle.getFloatValue("padding-left", 0),
			parsedStyle.getFloatValue("padding-top", 0),
			parsedStyle.getFloatValue("padding-right", 0),
			parsedStyle.getFloatValue("padding-bottom", 0));


		//pos-=size * pivot;

		var center = pos.copy();
		center.x += size.x * 0.5 + (padding.left - padding.right);
		center.y += size.y * 0.5 + (padding.top - padding.bottom);

		g2.font = font;
		g2.color = parsedStyle.getColorValue("background-color", kha.Color.Red);
		g2.fontSize = parsedStyle.getIntValue("font-size", 12);


		var textSize = new Vector2();
		textSize.x = g2.font.width(g2.fontSize, text) * 0.5;
		textSize.y = g2.font.height(g2.fontSize) * 0.5;


		g2.fillRect(pos.x, pos.y, size.x, size.y);
		g2.color = parsedStyle.getColorValue("text-color");
		g2.drawString(text, center.x - textSize.x, center.y - textSize.y);

	}

	public function canBeTargeted():Bool {
		return true;
	}

	public function onPointerEntered() {
		parsedStyle.setState("hovered");
	}

	public function onPointerExited() {
		parsedStyle.resetState();
	}

	public function canBeFocused():Bool {
		return true;
	}

	public function onFocused() {}

	public function onFocusLost() {}

	public function isFocused():Bool {
		return true;
	}

	public function onPressed(data:PointerEventData) {
		parsedStyle.setState("pressed");
	}

	public function onReleased(data:PointerEventData) {
		parsedStyle.setState("hovered");
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
