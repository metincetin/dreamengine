package dreamengine.plugins.physics_2d.shapes;

import haxe.exceptions.NotImplementedException;
import box2D.collision.shapes.B2Shape;

class CollisionShape{
	var cachedB2Shape: B2Shape;

	public final function createB2DShape():B2Shape {
		cachedB2Shape = createB2Shape_internal();
		return cachedB2Shape;
	}

	function createB2Shape_internal():B2Shape{
		throw new haxe.exceptions.NotImplementedException();
	}



	public function getCreateB2Shape(){
		if (cachedB2Shape != null)
			return cachedB2Shape;
		else return createB2DShape();
	}

	public function getB2Shape():B2Shape {
		return cachedB2Shape;
	}
}