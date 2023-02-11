package dreamengine.plugins.physics_2d.shapes;

import box2D.collision.shapes.B2Shape;
import box2D.common.math.B2Vec2;
import box2D.collision.shapes.B2EdgeShape;
import dreamengine.core.math.Vector.Vector2;

class EdgeCollisionShape extends CollisionShape{
    var p1:Vector2;
    var p2:Vector2;

    function new(){}

    public static function create(p1:Vector2, p2:Vector2){
        var s = new EdgeCollisionShape();
        s.p1 = p1;
        s.p2 = p2;

        return s;
    }

    override function createB2Shape_internal():B2Shape {
        var shape = new B2EdgeShape(new B2Vec2(p1.x, p1.y), new B2Vec2(p2.x, p2.y));
        return shape;
    }
}