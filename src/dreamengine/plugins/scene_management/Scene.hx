package dreamengine.plugins.scene_management;

import dreamengine.core.Engine;

class Scene{

    public function new(){} 

    public final function load(engine:Engine){
        // handle loading here.

        this.onLoaded(engine);
    }

    public final function unload(engine:Engine){
        // handle unloading

        this.onUnloaded(engine);
    }

    public function getName(){
        return "Scene";
    }

    public function isLoaded(){
        return true;
    }

    function onLoaded(engine:Engine){}
    function onUnloaded(engine:Engine){}
}