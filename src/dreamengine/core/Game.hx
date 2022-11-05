package dreamengine.core;

import dreamengine.core.Plugin.IPlugin;

class Game implements IPlugin {

	public function new(){}

	public function initialize(engine:Engine) {}

	public function finalize() {}

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
