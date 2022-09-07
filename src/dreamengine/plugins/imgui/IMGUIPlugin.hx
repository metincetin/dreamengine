package dreamengine.plugins.imgui;

import kha.Assets;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class IMGUIPlugin implements IPlugin {
	public function new() {}

	public function initialize(engine:Engine) {
		engine.registerRenderEvent(render);
	}

	public function finalize() {}

	function render(fb:Framebuffer) {
		fb.g2.begin(false);
		fb.g2.font = Assets.fonts.OpenSans_Regular;
		fb.g2.fontSize = 14;
		for (renderer in RenderStack.renderers) {
			renderer.render(fb.g2);
		}
		fb.g2.end();

		RenderStack.clear();
	}

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
