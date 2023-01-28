package dreamengine.plugins.physics_2d.components;

import dreamengine.plugins.physics_2d.components.RigidBody2D;
import dreamengine.plugins.ecs.Component;

class Collision2D extends Component {
	var collisions:Array<Collision>;

	public function hasCollision() {
		return collisions.length > 0;
	}

	public function getCollisionCount() {
		return collisions.length;
	}

	public function getCollision(index:Int) {
		return collisions[index];
	}

	public function getFirstCollision() {
		return getCollision(0);
	}
}

typedef Collision = {
	otherBody:RigidBody2D
};
