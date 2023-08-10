package dreamengine.plugins.dreamui.elements;

import kha.graphics2.Graphics;

class Box extends Element {
	public var color:kha.Color;

	public function new() {
		super();
	}

	override function onRender(g2:Graphics, opacity:Float) {
		g2.color = color;
		var rect = getRect();
		var pos = rect.getPosition();
		var size = rect.getSize();
		g2.fillRect(pos.x, pos.y, size.x, size.y);
		g2.color = kha.Color.White;
	}

	override function parseStyle() {
		super.parseStyle();
		color = parsedStyle.getColorValue("background-color", kha.Color.White);
	}
}
