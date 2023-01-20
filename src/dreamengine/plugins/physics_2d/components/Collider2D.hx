package dreamengine.plugins.physics_2d.components;

import dreamengine.plugins.physics_2d.shapes.CollisionShape;
import dreamengine.plugins.ecs.Entity;
import dreamengine.plugins.ecs.Component;

class Collider2D extends Component{

    var shape:CollisionShape;

    public function getShape(){
        return shape;
    }
    public function setShape(value:CollisionShape){
        shape = value;
    }

    public function new(shape:CollisionShape){
        super();
        this.shape = shape;
    }

    override function onAdded(entity:Entity) {
        var rb = entity.getComponent(RigidBody2D);
        if (rb != null){
            rb.setShape(shape);
        }
    }
}