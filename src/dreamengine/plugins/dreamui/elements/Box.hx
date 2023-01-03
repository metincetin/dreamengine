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
		g2.fillRect(rect.position.x, rect.position.y, rect.size.x, rect.size.y);
		g2.color = kha.Color.White;
	}
}
