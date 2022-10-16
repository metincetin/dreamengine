package dreamengine.plugins.dreamui.elements;

import kha.Font;
import kha.graphics2.Graphics;

class Label extends Element {
	var text = "";
	var font:Font;
	var fontSize = 12;

	public function setFont(font:Font) {
		this.font = font;
	}

	public function setFontSize(fontSize:Int) {
		this.fontSize = fontSize;
	}

	public function new(text:String = "") {
		super();
		this.text = text;
	}

	public function getText() {
		return text;
	}

	public function setText(text:String) {
		this.text = text;
	}

	override function onRender(g2:Graphics, opacity:Float) {
		g2.font = this.font;
		var cachedFontSize = g2.fontSize;
		g2.fontSize = fontSize;
		g2.drawString(text, getSlot().getPosition().x, getSlot().getPosition().y);
		g2.fontSize = cachedFontSize;
	}
}
