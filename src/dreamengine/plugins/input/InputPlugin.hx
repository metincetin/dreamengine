package dreamengine.plugins.input;

import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

/// handles basic input
class InputPlugin implements IPlugin {
	var inputHandler:IInputHandler;

	public function new(inputHandler:IInputHandler) {
		this.inputHandler = inputHandler;
		if (this.inputHandler == null) {
			throw "Input handler should not be null.";
		}
	}

	public function getInputHandler():IInputHandler {
		return inputHandler;
	}

	public function initialize(engine:Engine) {
		inputHandler.begin();
		engine.registerLoopEvent(loop);
	}

	function loop() {
		inputHandler.tick();
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
