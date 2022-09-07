package dreamengine.plugins.imgui;

import dreamengine.plugins.imgui.IMGUI.IMGUIRenderer;

class RenderStack {
	public static var renderers:Array<IMGUIRenderer> = new Array<IMGUIRenderer>();

	public static function add(renderer:IMGUIRenderer) {
		renderers.push(renderer);
	}

	public static function clear() {
		untyped renderers.length = 0;
	}
}
