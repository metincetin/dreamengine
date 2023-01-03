package dreamengine.plugins.post_processing;

import kha.Framebuffer;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class PostProcessPlugin implements IPlugin{

    private var stack:PostProcessStack;

    public function getStack(){
        return stack;
    }

    public function setStack(stack:PostProcessStack){
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

    function onRender(framebuffer:Framebuffer){
        
    }
}