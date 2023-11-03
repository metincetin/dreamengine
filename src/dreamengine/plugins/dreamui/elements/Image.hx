package dreamengine.plugins.dreamui.elements;

import kha.Color;
import dreamengine.core.math.Vector2;
import kha.graphics2.Graphics;

class Image extends Element {
	public var image:kha.Image;

	public var preserveAspect = false;

	var backgroundColor:Color = White;

	public function new(?image:kha.Image) {
		super();
		this.image = image;
	}

	override function parseStyle() {
		super.parseStyle();
		this.backgroundColor = parsedStyle.getColorValue("background-color", Color.White);
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

		if (image == null){
			g2.color = backgroundColor;
			g2.fillRect(pos.x, pos.y, size.x, size.y);
			g2.color = White;
		}else{
			g2.drawScaledImage(image, pos.x, pos.y, pos.x, pos.y);
		}
	}
	override function getPreferredSize():Vector2 {
		if (image == null) return [0,0];
		return [image.width, image.height];
	}
}

enum FillType {
	Stretch;
	PreserveAspect;
	PreserveAspectCentered;
}
