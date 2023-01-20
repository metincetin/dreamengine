package dreamengine.plugins.renderer_2d.components;

import dreamengine.plugins.renderer_base.components.Material;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.core.math.Vector.Vector3;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.core.math.Rect;
import kha.Image;
import dreamengine.plugins.ecs.Component;

class Sprite extends Component {
	var image:Image;

	public var flip:Bool = false;

	var ppu:Float = 100;

	public var pivot:Vector2 = Vector2.half();

	public function new(image:Image, ppu:Float = 100, flip = false) {
		super();
		this.image = image;
		this.flip = flip;
		this.ppu = ppu;
	}

	public function getPPU() {
		return ppu;
	}

	public function getImage() {
		return image;
	}

	public function setImage(image:Image) {
		this.image = image;
	}

	public function getLocalRect() {
		var rect = Rect.zero();

		var ppuScale = image.width / ppu * 0.1;

		var vFlipMultiplier = flip ? -1 : 1;

		// do pivot here
		var pivotOffset = new Vector2(image.width * -pivot.x, image.height * -pivot.y);

		var size = new Vector2();
		
		size.x = image.width * vFlipMultiplier;
		size.y = image.height; 
		
		rect.setPosition(pivotOffset);
		rect.setSize(size);
		return rect;
	}
}
