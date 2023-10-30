package dreamengine.plugins.renderer_3d.components;

import dreamengine.device.Screen;
import kha.math.FastMatrix2;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import dreamengine.plugins.ecs.Entity;
import kha.math.FastMatrix4;
import kha.graphics5_.TextureFormat;
import kha.Framebuffer;
import kha.Image;
import kha.Color;

class DirectionalLight extends Light {
	public var shadowMap:Image;
	public var viewMatrix:FastMatrix4 = FastMatrix4.identity();
	public var projectionMatrix:FastMatrix4 = FastMatrix4.identity();
	public var viewProjectionMatrix:FastMatrix4 = FastMatrix4.identity();

	public function new(color:Color = Color.White, intensity:Float = 1) {
		super(color, intensity);
	}

	override function onAdded(entity:Entity) {
		shadowMap = Image.createRenderTarget(2048, 2048, TextureFormat.DEPTH16);
		projectionMatrix = FastMatrix4.orthogonalProjection(-5, 5, -5, 5, 1, 10);
	}

	override function onRemoved(entity:Entity) {}

	public function getViewMatrix():FastMatrix4 {
		return viewMatrix;
	}

	public function getProjectionMatrix():FastMatrix4 {
		return projectionMatrix;
	}

	public function getViewProjectionMatrix():FastMatrix4 {
		return viewProjectionMatrix;
	}

	public function getRenderTarget():Image {
		return shadowMap;
	}
}
