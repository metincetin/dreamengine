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

		if (preserveAspect) {
			if (rect.size.x > rect.size.y) {
				rect.size.x = rect.size.y;
			} else {
				rect.size.y = rect.size.x;
			}
		}

		g2.drawScaledImage(image, rect.position.x, rect.position.y, rect.size.x, rect.size.y);
	}
}

enum FillType {
	Stretch;
	PreserveAspect;
	PreserveAspectCentered;
}
