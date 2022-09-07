package dreamengine.plugins.core_audio;

import dreamengine.core.Plugin.IPlugin;

class CoreAudio implements IPlugin {
	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
		return null;
	}
}
