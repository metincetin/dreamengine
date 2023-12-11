package dreamengine.plugins.dreamui;

import kha.graphics4.PipelineState;
import dreamengine.plugins.dreamui.styling.Style;
import dreamengine.device.Screen;
import dreamengine.plugins.dreamui.containers.*;
import dreamengine.plugins.dreamui.elements.*;
import dreamengine.plugins.dreamui.utils.UIXMLElementTypes;
import dreamengine.plugins.input.handlers.kha.KhaInputHandler;
import dreamengine.plugins.input.InputPlugin;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class DreamUIPlugin implements IPlugin {
	var screen:Element;

	var mainElement:Element;

	var eventSystem:EventSystem;

	var pipeline: PipelineState;

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
		UIXMLElementTypes.registerType("InputField", InputField);
		UIXMLElementTypes.registerType("ListView", ListView);
		UIXMLElementTypes.registerType("Slider", Slider);

		UIXMLElementTypes.registerType("Box", Box);

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

		engine.registerLoopEvent(onLoop);

		eventSystem = new EventSystem(this, inputPlugin.getInputHandler());
		screen = new ScreenContainer();
		screen.setStyle(Style.fromJson(kha.Assets.blobs.defaultStyle_json.readUtf8String()));

		// set up main theme here
		Screen.registerSizeChangeListener(onScreenResolutionChanged);

		// registering render pass
		engine.getRenderer().pipeline.push(new DreamUIRenderPass(this));
	}

	function onScreenResolutionChanged(width:Int, height:Int){
		screen.setDirty();
	}

	function onLoop() {
		eventSystem.update();
	}

	public function finalize() {
		Screen.unregisterSizeChangeListener(onScreenResolutionChanged);
	}

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
