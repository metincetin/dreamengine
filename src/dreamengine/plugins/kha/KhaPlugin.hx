package dreamengine.plugins.kha;

import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class KhaPlugin implements IPlugin{
    
    public function new(){
    }
    
	public function initialize(engine:Engine) {
    }



	public function finalize() {
    }

	public function getName():String {
        return "kha";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
        return [];
    }
    public function handleDependency(ofType:Class<IPlugin>){
        return null;
    }
}