package dreamengine.plugins.scene_management;

import dreamengine.plugins.ecs.ECS;
import dreamengine.plugins.ecs.Entity;
import haxe.rtti.XmlParser;

class SceneInstance extends Entity{

    var ecs:ECS;
    public function new(ecs:ECS){
        super();
        this.ecs = ecs;
    }

    override function onSpawned() {
        
    }

    override function onDespawned() {
        
    }

    static function loadFromXML(){
        var xml = Xml.parse("");
        var root = xml.firstElement();
        for (entityElement in root.elements()){
            if (entityElement.nodeType.toString() == "Entity"){

            }
        }
    }
}