package dreamengine.plugins.renderer_3d.components;

import kha.graphics5_.TextureFormat;
import kha.Framebuffer;
import kha.Image;
import kha.Color;

class DirectionalLight extends Light {
	public var shadowMap:Image;
	public function new(color:Color = Color.White, intensity:Float = 1) {
		super(color, intensity);
		shadowMap = Image.createRenderTarget(1024,1024, TextureFormat.DEPTH16);
	}
}
