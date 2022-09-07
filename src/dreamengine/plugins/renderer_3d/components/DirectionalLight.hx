package dreamengine.plugins.renderer_3d.components;

import kha.Color;

class DirectionalLight extends Light {
	public function new(color:Color = Color.White, intensity:Float = 1) {
		super(color, intensity);
	}
}
