package dreamengine.plugins.renderer_2d.components;

import dreamengine.core.math.Vector2i;
import dreamengine.plugins.renderer_3d.Primitives;
import dreamengine.core.Renderable;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.core.math.Vector3;
import dreamengine.core.math.Vector2;
import dreamengine.core.math.Rect;
import kha.Image;
import dreamengine.plugins.ecs.Component;

class Sprite extends Component {
	var image:Image;
	var renderable:Renderable;

	public var flip:Bool = false;

	var ppu:Float = 100;

	public var pivot:Vector2 = Vector2.half();

	var scale:Vector3;
	var position:Vector3;
	var euler:Vector3;

	public function getPosition(value:Vector3){
		return position;
	}
	
	public function getEuler(value:Vector3){
		return euler;
	}

	public function getScale(value:Vector3){
		return scale;
	}

	public function setPosition(value:Vector3){
		position = value;
	}
	
	public function setEuler(value:Vector3){
		euler = value;
	}

	public function setScale(value:Vector3){
		scale = value;
	}

	public function new(image:Image, ppu:Float = 100, flip = false) {
		super();
		this.image = image;
		this.flip = flip;
		this.ppu = ppu;
		renderable = new Renderable();
		renderable.material = Renderer2D.getDefaultMaterial().copy();
		renderable.material.setTextureUniform("u_Texture", image);
		renderable.mesh = Primitives.quadMesh;
	}

	public function getPPU() {
		return ppu;
	}
	public function getPPUScale(){
		if (image == null) return Vector3.one();
		var imageSize:Vector2i = new Vector2i(image.realWidth, image.realHeight);
		var sx = imageSize.x / ppu;
		var sy = imageSize.y / ppu;
		return new Vector2(sx, sy);
	}

	public function getImage() {
		return image;
	}

	public function getRenderable(){
		return renderable;
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
