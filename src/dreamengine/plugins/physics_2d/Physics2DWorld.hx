package dreamengine.plugins.physics_2d;

import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import box2D.collision.B2RayCastOutput;
import box2D.common.math.B2Vec2;
import dreamengine.core.math.Vector.Vector2;
import box2D.collision.B2RayCastInput;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;

class Physics2DWorld {
	var b2World:B2World;

	public function new(w:B2World) {
		this.b2World = w;
	}

	public function getB2World() {
		return b2World;
	}

	public function raycast(origin:Vector2, direction:Vector2, distance:Float):RayHitResult {
		var body = b2World.getBodyList();

		var input = new B2RayCastInput(new B2Vec2(origin.x, origin.y));
		var v2:Vector2;
		v2 = direction.scaled(distance);

		input.p2 = new B2Vec2(v2.x, v2.y);
		input.maxFraction = 1;

		while (body != null){
			var fixture = body.getFixtureList();
			while (fixture != null){
				var output = new B2RayCastOutput();
				if (fixture.rayCast(output, input)) {
					var hitResult:RayHitResult = {
                        normal: new Vector2(output.normal.x, output.normal.y)
                    };
                    return hitResult;
				}

				fixture = fixture.getNext();
			} 

			body = body.getNext();
		}
        return null;
	}

	public function step(delta:Float, velocityIterations:Int, positionIterations:Int) {
        b2World.step(delta, velocityIterations, positionIterations);
    }
}
