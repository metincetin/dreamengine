package dreamengine.plugins.post_processing;

import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.renderer_base.ActiveCamera;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class PostProcessPlugin implements IPlugin {
    public function new(){}
	private var stack:PostProcessStack;

	public function getStack() {
		return stack;
	}

	public function setStack(stack:PostProcessStack) {
		this.stack = stack;
	}

	public function initialize(engine:Engine) {
		engine.registerRenderEvent(onRender);
	}

	public function finalize() {}

	public function getName():String {
		return "PostProcessing";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
		return null;
	}

	function onRender(framebuffer:Framebuffer) {
        if (stack == null) return;
		for (i in 0...ActiveView.getViewCount()) {
            var view = ActiveView.getView(i);
			if (view is Camera){
            	stack.render(view.getRenderTarget(), framebuffer);
			}
        }
	}
}
