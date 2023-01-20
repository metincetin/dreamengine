package dreamengine.plugins.physics_2d.shapes;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2Shape;

class CircleCollisionShape extends CollisionShape{
    var radius:Float;

    function new(){}

    public static function create(radius:Float){
        var s = new CircleCollisionShape();
        s.radius = radius;

        return s;
    }

    override function createB2DShape():B2Shape {
        return new B2CircleShape(radius);
    }
}