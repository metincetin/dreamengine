package dreamengine.plugins.post_processing;

import dreamengine.plugins.renderer_base.components.Camera;
import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.plugins.post_processing.passes.PostProcessPass;

class PostProcessPlugin implements IPlugin {
    public function new(){}
	private var stack:PostProcessStack;
	var pass:PostProcessPass;

	public function getStack() {
		return stack;
	}

	public function setStack(stack:PostProcessStack) {
		this.stack = stack;
	}

	public function initialize(engine:Engine) {
		pass = new PostProcessPass(this);
		engine.getRenderer().pipeline.push(pass);
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
}
