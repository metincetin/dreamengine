package dreamengine.plugins.windowing;

import dreamengine.core.Engine;
import dreamengine.core.Plugin;

class Window{
	var title:String = "New Window";

	public function new(title:String){
		this.title = title;
	}
}

class WindowSystem implements IPlugin{
	var activeWindows:Array<Window> = new Array<Window>();
	public function new(){}

	public function initialize(engine:Engine) {}

	public function finalize() {}

	public function getName():String {
        return "window_system";
	}

	public function createWindow(title:String): Window {
		var win = new Window(title);
		activeWindows.push(win);
		return win;
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}
	public function handleDependency(ofType:Class<IPlugin>){
        return null;
    }
}