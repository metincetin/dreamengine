package dreamengine.plugins.renderer_2d.components;

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

	public function getDrawRect(transform:Transform) {
		var rect = Rect.zero();

		var pos = transform.getPosition();
		var scale = transform.getScale();
		var ppuScale = image.width / ppu * 0.1;
		scale = Vector3.multiply(scale, ppuScale);

		var vFlipMultiplier = flip ? -1 : 1;

		// do pivot here
		var pivotOffset = new Vector3(image.width * pivot.x, image.height * pivot.y);

		var actualPosition = new Vector3(pos.x - pivotOffset.x * scale.x, pos.y - pivotOffset.y * scale.y);
		rect.position = actualPosition.asVector2();
		rect.size.x = image.width * scale.x * vFlipMultiplier;
		rect.size.y = image.height * scale.y;

		return rect;
	}
}
