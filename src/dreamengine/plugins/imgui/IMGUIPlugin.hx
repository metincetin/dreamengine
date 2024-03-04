package dreamengine.plugins.imgui;

import kha.Assets;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class IMGUIPlugin implements IPlugin {
	public function new() {}

	var engine:Engine;
	public function initialize(engine:Engine) {
		this.engine = engine;
		engine.getRenderer().pipeline.push(new IMGUIRenderPass());
		engine.registerPostLoopEvent(onTickLate);
		engine.registerPreLoopEvent(onTickPre);
	}

	function onTickPre(){
        RenderStack.clear();
	}

	function onTickLate(){
		IMGUIRenderPass.waitingRenderer = true;
	}

	public function finalize() {
		engine.unregisterPreLoopEvent(onTickPre);
		engine.unregisterPostLoopEvent(onTickLate);
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
