package dreamengine.plugins.renderer_2d.components;

import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.core.math.Vector3;
import dreamengine.core.math.Vector2;
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

		var ppuScale = ppu * 0.005;

		var vFlipMultiplier = flip ? -1 : 1;

		var ppuScaled = new Vector2(image.width / ppuScale, image.height / ppuScale);

		var pivotOffset = new Vector2(ppuScaled.x * -pivot.x, ppuScaled.y * -pivot.y);


		var size = new Vector2();
		
		size.x = ppuScaled.x * vFlipMultiplier;
		size.y = ppuScaled.y; 
		
		rect.setPosition(pivotOffset);
		rect.setSize(size);
		return rect;
	}
}
