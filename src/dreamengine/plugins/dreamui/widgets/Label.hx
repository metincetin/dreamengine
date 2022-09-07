package dreamengine.plugins.dreamui.widgets;

import kha.Font;
import kha.graphics2.Graphics;

class Label extends Widget {
	var text = "";
	var font:Font;

	public function setFont(font:Font) {
		this.font = font;
	}

	public function new(text:String = "") {
		super();
		this.text = text;
	}

	override function onRender(g2:Graphics) {
		g2.font = this.font;
		g2.drawString(text, 0, 0);
	}
}
