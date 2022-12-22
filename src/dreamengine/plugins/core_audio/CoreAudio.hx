package dreamengine.plugins.core_audio;

import kha.audio1.Audio;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class CoreAudio implements IPlugin {
	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
		return null;
	}

	public function initialize(engine:Engine) {}

	public function finalize() {}

	public function getName():String {
		return "core_audio";
	}

	public function playAudio(sound: kha.Sound, volume = 1.0, loop = false){
		var audioChannel = Audio.play(sound, loop);
		audioChannel.volume = volume;
		return audioChannel;
	}
}
