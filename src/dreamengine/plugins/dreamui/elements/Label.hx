package dreamengine.plugins.dreamui.elements;

import dreamengine.plugins.dreamui.utils.TextRenderingUtils;
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

		var renderPos = TextRenderingUtils.getAlignedPosition(getRect(), getPreferredSize(), alignment);

		g2.drawString(text, renderPos.x, renderPos.y); 
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