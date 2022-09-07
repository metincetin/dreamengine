package dreamengine.plugins.dreamui.widgets;

import kha.graphics2.Graphics;

class Line extends Widget {
	public var thickness = 1.0;

	public function new() {
		super();
	}

	override function onRender(g2:Graphics) {
		g2.drawLine(0, 0, 0, 0, thickness);
	}
}
