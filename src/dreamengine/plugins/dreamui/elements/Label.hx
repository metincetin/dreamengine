package dreamengine.plugins.dreamui.elements;

import dreamengine.core.math.Vector.Vector2;
import kha.Font;
import kha.graphics2.Graphics;

class Label extends Element {
	var text = "";
	var font:Font;
	var fontSize = 12;

	var alignment:Alignment = TopLeft;

	public function getAlignment(){
		return alignment;
	}
	public function setAlignment(value:Alignment){
		this.alignment = value;
	}

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
	override function getPreferredSize():Vector2 {
		return new Vector2(
			font.width(fontSize, text),
			font.height(fontSize)
		);
	}

	override function onRender(g2:Graphics, opacity:Float) {
		g2.font = this.font;
		var cachedFontSize = g2.fontSize;
		g2.fontSize = fontSize;

		var position = getRect().position;
		var size = getRect().size;
		var offset = Vector2.zero();
		var prefSize = getPreferredSize();

		switch(alignment){
			case TopLeft:
				offset.x = 0;
				offset.y = 0;
			case TopCenter:
				offset.x = size.x * 0.5 - prefSize.x * 0.5;
				offset.y = 0;
			case TopRight:
				offset.x = size.x - prefSize.x;
				offset.y = 0;
			case MiddleLeft:
				offset.x = 0;
				offset.y = size.y * 0.5 - prefSize.y * 0.5;
			case MiddleCenter:
				offset.x = size.x * 0.5 - prefSize.x * 0.5;
				offset.y = size.y * 0.5 - prefSize.y * 0.5;
			case MiddleRight:
				offset.x = size.x - prefSize.x;
				offset.y = size.y * 0.5 - prefSize.y * 0.5;
			case BottomLeft:
				offset.x = 0;
				offset.y = size.y - prefSize.y;
			case BottomCenter:
				offset.x = size.x * 0.5 - prefSize.x * 0.5;
				offset.y = size.y - prefSize.y;
			case BottomRight:
				offset.x = size.x - prefSize.x;
				offset.y = size.y - prefSize.y;
		}

		g2.drawString(text, position.x + offset.x, position.y + offset.y);
		g2.fontSize = cachedFontSize;
	}
}

enum Alignment{
	TopLeft;
	TopCenter;
	TopRight;
	MiddleLeft;
	MiddleCenter;
	MiddleRight;
	BottomLeft;
	BottomCenter;
	BottomRight;
}