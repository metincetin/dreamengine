package dreamengine.plugins.dreamui;

import dreamengine.plugins.dreamui.containers.FillContainer;
import dreamengine.plugins.dreamui.containers.ElementSwitcher;
import dreamengine.plugins.dreamui.containers.HorizontalBoxContainer;
import dreamengine.plugins.dreamui.layout_parameters.VerticalBoxLayoutParameters.HorizontalAlignment;
import dreamengine.plugins.dreamui.containers.VerticalBoxContainer;
import dreamengine.plugins.dreamui.elements.ToggleBox;
import dreamengine.plugins.dreamui.elements.Image;
import dreamengine.plugins.dreamui.containers.CanvasContainer;
import dreamengine.plugins.dreamui.elements.Label;
import dreamengine.plugins.dreamui.elements.Button;
import dreamengine.plugins.dreamui.utils.UIXMLElementTypes;
import dreamengine.plugins.dreamui.containers.ScreenContainer;
import dreamengine.plugins.input.handlers.kha.KhaInputHandler;
import dreamengine.plugins.input.InputPlugin;
import dreamengine.core.math.Vector2;
import dreamengine.core.Time;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class DreamUIPlugin implements IPlugin {
	var screen:Element;

	var mainElement:Element;

	var eventSystem:EventSystem;

	public function new() {
		registerTypes();
	}

	function registerTypes() {
		// elements

		UIXMLElementTypes.registerType("Element", Element);
		UIXMLElementTypes.registerType("Button", Button);
		UIXMLElementTypes.registerType("Label", Label);
		UIXMLElementTypes.registerType("Image", Image);
		UIXMLElementTypes.registerType("ToggleBox", ToggleBox);

		// containers

		UIXMLElementTypes.registerType("ScreenContainer", ScreenContainer);
		UIXMLElementTypes.registerType("CanvasContainer", CanvasContainer);
		UIXMLElementTypes.registerType("HorizontalBoxContainer", HorizontalBoxContainer);
		UIXMLElementTypes.registerType("VerticalBoxContainer", VerticalBoxContainer);
		UIXMLElementTypes.registerType("ElementSwitcher", ElementSwitcher);
		UIXMLElementTypes.registerType("FillContainer", FillContainer);
	}

	public function getScreenElement() {
		return screen;
	}

	public function setMainElement(w:Element) {
		mainElement = w;
		screen.addChild(mainElement);
	}

	public function getMainElement() {
		return mainElement;
	}

	public function initialize(engine:Engine) {
		var inputPlugin = engine.pluginContainer.getPlugin(InputPlugin);

		if (inputPlugin == null) {
			throw "Input plugin not found";
		}

		engine.registerRenderEvent(onRender);
		engine.registerLoopEvent(onLoop);

		eventSystem = new EventSystem(this, inputPlugin.getInputHandler());
		screen = new ScreenContainer();
		// set up main theme here
	}

	function onLoop() {
		eventSystem.update();
	}

	function onRender(fb:Framebuffer) {
		if (mainElement == null)
			return;
		fb.g2.begin(true);
		screen.render(fb.g2, 1);
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
