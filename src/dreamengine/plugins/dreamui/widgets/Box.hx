package dreamengine.plugins.dreamui.widgets;

import kha.graphics2.Graphics;

class Box extends Widget {
	public function new() {
		super();
	}

	override function onRender(g2:Graphics) {
		var pos = getSlot().getPosition();
		var size = getSlot().getSize();
		g2.fillRect(pos.x, pos.y, size.x, size.y);
	}
}
