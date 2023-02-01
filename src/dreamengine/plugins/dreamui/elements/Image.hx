package dreamengine.plugins.dreamui.elements;

import kha.graphics2.Graphics;

class Image extends Element {
	public var image:kha.Image;

	public var preserveAspect = false;

	public function new(?image:kha.Image) {
		super();
		this.image = image;
	}

	override function onRender(g2:Graphics, opacity:Float) {
		var rect = getRect();
		var size = rect.getSize();
		var pos = rect.getPosition();

		if (preserveAspect) {
			if (size.x > size.y) {
				size.x = size.y;
			} else {
				size.y = size.x;
			}
		}

		g2.drawScaledImage(image, pos.x, pos.y, pos.x, pos.y);
	}
}

enum FillType {
	Stretch;
	PreserveAspect;
	PreserveAspectCentered;
}
