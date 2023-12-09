package dreamengine.plugins.input;

import dreamengine.plugins.input.handlers.kha.KhaInputHandler;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

/// handles basic input
class InputPlugin implements IPlugin {
	var inputHandler:IInputHandler;
	public var inputMap:InputMap;

	public function new(inputHandler:IInputHandler = null) {
		if (this.inputHandler == null) {
			inputHandler = new KhaInputHandler();
		}
		this.inputHandler = inputHandler;
	}

	public function getInputHandler():IInputHandler {
		return inputHandler;
	}

	public function initialize(engine:Engine) {
		inputHandler.begin();
		engine.registerLoopEvent(loop);
		engine.registerPostLoopEvent(postLoop);
	}

	function loop() {
		inputHandler.tick();
	}
	function postLoop(){
		inputHandler.postTick();
	}

	public function finalize() {
		inputHandler.end();
	}

	public function getName():String {
		return "input";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>) {
		return null;
	}
}
