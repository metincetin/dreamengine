package dreamengine.plugins.physics_2d.shapes;

import box2D.common.math.B2Vec2;
import box2D.collision.shapes.B2PolygonShape;
import dreamengine.core.math.Vector.Vector2;
import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2Shape;

class BoxCollisionShape extends CollisionShape{
    var extents:Vector2;

    function new(){}

    public static function create(extents:Vector2){
        var s = new BoxCollisionShape();
        s.extents = extents;

        return s;
    }

    override function createB2Shape_internal():B2Shape {
        var shape = new B2PolygonShape();
        shape.setAsBox(extents.x, extents.y);
        return shape;
    }
}