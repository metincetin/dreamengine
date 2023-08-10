package dreamengine.device;

import kha.*;
import dreamengine.core.math.Vector2i;

class Screen {
	static var isInitialized = false;

	static var resizeListeners = new Array<(Int, Int) -> Void>();

	public static function initialize() {
		if (isInitialized)
			return;
		isInitialized = true;

		getWindow().notifyOnResize(onResized);
	}

    public static function registerSizeChangeListener(listener:(Int,Int) -> Void){
        resizeListeners.push(listener);
    }

    public static function unregisterSizeChangeListener(listener:(Int,Int) -> Void){
        resizeListeners.remove(listener);
    }

	static function onResized(width:Int, height:Int) {
		for (ev in resizeListeners) {
            ev(width,height);
        }
	}

	public static function getResolution() {
		var win = getWindow();
		return new Vector2i(win.width, win.height);
	}

	public static function setResolution(width:Int, height:Int) {
		var win = getWindow();
		win.resize(width, height);
	}

	static function getWindow(index = 0):kha.Window {
		return kha.Window.get(index);
	}

	public static function setWindowFeatures(windowFeatures:Int) {
		getWindow().changeWindowFeatures(windowFeatures);
	}

	public static function getWindowMode(windowFeatures:Int) {
		return getWindow().mode;
	}

	public static function setWindowMode(mode:WindowMode) {
		getWindow().mode = mode;
	}
}
