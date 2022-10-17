package dreamengine.plugins.dreamui.elements;

import kha.graphics2.Graphics;

class Line extends Element {
	public var thickness = 1.0;

	public function new() {
		super();
	}

	override function onRender(g2:Graphics, opacity:Float) {
		g2.drawLine(0, 0, 0, 0, thickness);
	}
}
