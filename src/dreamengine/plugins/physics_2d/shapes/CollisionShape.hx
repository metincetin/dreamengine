package dreamengine.plugins.physics_2d.shapes;

import haxe.exceptions.NotImplementedException;
import box2D.collision.shapes.B2Shape;

class CollisionShape{
    function toB2dShape(): B2Shape{
        throw NotImplementedException;
    }

	public function createB2DShape():B2Shape {
		throw new haxe.exceptions.NotImplementedException();
	}
}