package dreamengine.plugins.scene_management;

import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class SceneManagementPlugin implements IPlugin{
	private var activeScenes:Array<Scene> = [];

    private var engine:Engine;
    public function new(){}

    function getActiveSceneCount(){
        return activeScenes.length;
    }
	function getActiveScene(index:Int) {
		return activeScenes[index];
	}

    public function initialize(engine:Engine){
        this.engine = engine;
    }

    public function addScene(scene:Scene){
        activeScenes.push(scene);
        scene.load(engine);
    }
    public function removeScene(scene:Scene){
        if (activeScenes.remove(scene)){
            scene.unload(engine);
        }
    }
    public function replaceScenes(scene:Scene){
        removeAllScenes();
        addScene(scene);
    }
    public function removeAllScenes(){
        for(scene in activeScenes){
            scene.unload(engine);
        }

        activeScenes = [];
    }


	public function finalize() {}

	public function getName():String {
        return "SceneManagement";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
        return [];
    }

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
        return null;
    }
}
