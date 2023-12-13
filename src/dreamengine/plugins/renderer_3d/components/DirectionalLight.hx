package dreamengine.plugins.renderer_3d.components;

import dreamengine.plugins.renderer_base.LightData;
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
	public var viewProjectionMatrix:FastMatrix4 = FastMatrix4.identity();

	public var data:LightData;

	public function new(color:Color = Color.White, intensity:Float = 1) {
		super(color, intensity);
		data = {
			position: null,
			direction: null,
			projection: null,
			viewProjection: null,
			intensity: intensity,
			color: color,
			range: null,
			type: Directional
		};
	}

	override function onAdded(entity:Entity) {
		data.projection = FastMatrix4.orthogonalProjection(-5, 5, -5, 5, 1, 30);
	}

	override function onRemoved(entity:Entity) {}

	public function getViewMatrix():FastMatrix4 {
		return viewMatrix;
	}

	public function getProjectionMatrix():FastMatrix4 {
		return data.projection;
	}

	public function getViewProjectionMatrix():FastMatrix4 {
		return data.viewProjection;
	}

	public function getRenderTarget():Image {
		return shadowMap;
	}
}
