package dreamengine.plugins.dreamui;

import dreamengine.plugins.input.handlers.kha.KhaInputHandler;
import dreamengine.plugins.input.InputPlugin;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.core.Time;
import dreamengine.plugins.dreamui.slots.CanvasSlot;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class DreamUIPlugin implements IPlugin {
	var mainWidget:Widget;

	var eventSystem:EventSystem;

	public function new() {}

	public function setMainWidget(w:Widget) {
		mainWidget = w;
	}

	public function getMainWidget() {
		return mainWidget;
	}

	public function initialize(engine:Engine) {
		var inputPlugin = engine.pluginContainer.getPlugin(InputPlugin);

		if (inputPlugin == null) {
			throw "Input plugin not found";
		}

		engine.registerRenderEvent(onRender);
		engine.registerLoopEvent(onLoop);

		eventSystem = new EventSystem(this, inputPlugin.getInputHandler());
	}

	function onLoop() {
		eventSystem.update();
	}

	function onRender(fb:Framebuffer) {
		if (mainWidget == null)
			return;
		fb.g2.begin(false);
		mainWidget.render(fb.g2, 1);
		fb.g2.end();
	}

	public function finalize() {}

	public function getName():String {
		return "DreamUI";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [InputPlugin];
	}

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
		switch (ofType) {
			case InputPlugin:
				return new InputPlugin(new KhaInputHandler());
		}
		return null;
	}
}
