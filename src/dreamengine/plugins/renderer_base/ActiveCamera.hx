package dreamengine.plugins.renderer_base;

import kha.graphics5_.TextureFormat;
import dreamengine.device.Screen;
import kha.Image;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.renderer_base.components.Transform;

class ActiveView {
	static var views = new Array<IRenderView>();

	public static function getViewCount() {
		return views.length;
	}

	public static function getView(i:Int) {
		return views[i];
	}


	public static function registerView(view:IRenderView) {
		views.push(view);
	}

	public static function unregisterView(view:IRenderView) {
		views.remove(view);
	}
}
