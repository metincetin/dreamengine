package dreamengine.plugins.renderer_3d.components;

import kha.Color;

class PointLight extends Light {
	public var radius:Float;

	public function new(color:Color = Color.White, radius:Float, intensity:Float = 1) {
		super(color, intensity);
		this.radius = radius;
	}
}
