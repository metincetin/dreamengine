package dreamengine.plugins.dreamui.elements;

import kha.graphics2.Graphics;

class Box extends Element {
	public function new() {
		super();
	}

	override function onRender(g2:Graphics) {
		var pos = getSlot().getPosition();
		var size = getSlot().getSize();
		g2.fillRect(pos.x, pos.y, size.x, size.y);
	}
}
