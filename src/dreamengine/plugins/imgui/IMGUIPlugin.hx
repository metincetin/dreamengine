package dreamengine.plugins.imgui;

import kha.Assets;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class IMGUIPlugin implements IPlugin {
	public function new() {}

	public function initialize(engine:Engine) {
		engine.getRenderer().pipeline.push(new IMGUIRenderPass());
	}

	public function finalize() {}

	public function getName():String {
		return "IMGUI";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
		return null;
	}
}
