package dreamengine.plugins.renderer_base;

import kha.graphics5_.TextureFormat;
import dreamengine.device.Screen;
import kha.Image;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.renderer_base.components.Transform;

class ActiveCamera {
	static var cameras = new Array<Camera>();
	static var transforms = new Array<Transform>();

	public static function getCameraCount() {
		return cameras.length;
	}

	public static function getCamera(i:Int) {
		return cameras[i];
	}

	public static function getTransform(i:Int) {
		return transforms[i];
	}

	public static function registerCamera(camera:Camera, transform:Transform) {
		cameras.push(camera);
		transforms.push(transform);
	}

	public static function unregisterCamera(camera:Camera, transform:Transform) {
		cameras.remove(camera);
		transforms.remove(transform);
	}
}
