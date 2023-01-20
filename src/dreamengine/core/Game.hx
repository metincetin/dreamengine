package dreamengine.core;

import dreamengine.core.Plugin.IPlugin;

class Game implements IPlugin {

	var engine:Engine;

	public function new(){}

	public final function initialize(engine:Engine) {
		this.engine = engine;
		beginGame();
	}

	
	public final function finalize() {
		endGame();
	}
	
	function beginGame() {}
	function endGame() {}

	public function getName():String {
		return "dream_game";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
		return null;
	}
}
