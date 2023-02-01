package dreamengine.plugins.dreamui.elements;

import dreamengine.plugins.dreamui.utils.TextRenderingUtils;
import dreamengine.core.math.Vector.Vector2;
import kha.Font;
import kha.graphics2.Graphics;

class Label extends Element {
	var text = "";
	var font:Font;
	var fontSize:Int = 12;

	var alignment:Alignment = TopLeft;

	public function getAlignment() {
		return alignment;
	}

	public function setAlignment(value:Alignment) {
		this.alignment = value;
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
		return new Vector2(font.width(fontSize, text), font.height(fontSize));
	}

	override function onRender(g2:Graphics, opacity:Float) {
		this.font = g2.font;
		var cachedFontSize = g2.fontSize;
		g2.fontSize = fontSize;

		var renderPos = TextRenderingUtils.getAlignedPosition(getRect(), getPreferredSize(), alignment);

		g2.drawString(text, renderPos.x, renderPos.y);
		g2.fontSize = cachedFontSize;

		renderedRect.setSize(getPreferredSize());
		renderedRect.setPosition(renderPos);
	}

	override function parseStyle() {
		super.parseStyle();
		this.fontSize = parsedStyle.getIntValue("font-size", 12);
	}
}

@:enum abstract Alignment(Int) from Int {
	var TopLeft = 0;
	var TopCenter = 1;
	var TopRight = 2;
	var MiddleLeft = 3;
	var MiddleCenter = 4;
	var MiddleRight = 5;
	var BottomLeft = 6;
	var BottomCenter = 7;
	var BottomRight = 8;

	inline function new(i:Int) {
		this = i;
	}

	@:from
	static public function from(i:Int){
		return new Alignment(i);
	}

}
