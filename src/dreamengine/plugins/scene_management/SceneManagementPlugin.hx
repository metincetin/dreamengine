package dreamengine.plugins.scene_management;

import dreamengine.core.Engine;
import dreamengine.plugins.ecs.ECS;
import dreamengine.core.Plugin.IPlugin;

class SceneManagementPlugin implements IPlugin{

    public function new(){
    }


    public function initialize(engine:Engine) {
    }

	public function finalize() {
    }

	public function getName():String {
        return "scene_management";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [ECS];
	}
    public function handleDependency(ofType:Class<IPlugin>){
        if (ofType == ECS){
            return new ECS();
        }

        return null;
    }
}