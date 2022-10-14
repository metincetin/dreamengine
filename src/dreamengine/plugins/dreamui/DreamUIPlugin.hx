package dreamengine.plugins.dreamui;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.core.Time;
import dreamengine.plugins.dreamui.slots.CanvasSlot;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class DreamUIPlugin implements IPlugin {
	var mainWidget:Widget;

	public function new() {}

	public function setMainWidget(w:Widget) {
		mainWidget = w;
	}

	public function initialize(engine:Engine) {
		engine.registerRenderEvent(onRender);
	}

	function onRender(fb:Framebuffer) {
		if (mainWidget == null)
			return;
		fb.g2.begin(false);
		mainWidget.render(fb.g2);
		fb.g2.end();
	}

	public function finalize() {}

	public function getName():String {
		return "DreamUI";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
		return null;
	}
}
