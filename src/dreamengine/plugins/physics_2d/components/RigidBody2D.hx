package dreamengine.plugins.physics_2d.components;

import box2D.collision.shapes.B2MassData;
import box2D.dynamics.B2Body;
import dreamengine.plugins.physics_2d.shapes.CollisionShape;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.renderer_2d.components.Transform2D;
import dreamengine.plugins.ecs.Entity;
import box2D.common.math.B2Vec2;
import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2Shape;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import box2D.dynamics.B2BodyType;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.ecs.Component;

class RigidBody2D extends Component {
	var bodyDef:B2BodyDef;
	var fixtureDef:B2FixtureDef;

	var body:B2Body;
	var world:Physics2DWorld;

	var shape:CollisionShape;

	var transformRef:Transform;

	var bodyType = DYNAMIC_BODY;

	public function new(bodyType:B2BodyType) {
		super();
		bodyDef = new B2BodyDef();
		fixtureDef = new B2FixtureDef();
		fixtureDef.restitution = 0;
		fixtureDef.friction = 0;
		fixtureDef.density = 1;
		bodyDef.angularDamping = 0;
		//(-image.width / (ppuScale * 0.5) * 0.5), (-image.height / (ppuScale* 0.5) * 0.5), image.width / (ppuScale * 0.5), image.height / (ppuScale * 0.5)bodyDef.gravityScale = 0;
		this.bodyType = bodyType;
		bodyDef.allowSleep = false;
	}

	public function getWorld() {
		return world;
	}

	/// Sets the physics world entity currently in. Do not call it, as it will be handled by Physics2D plugin
	public function setWorld(world:Physics2DWorld) {
		this.world = world;
		body = world.getB2World().createBody(bodyDef);
		setPosition(transformRef.getPosition().asVector2());
		body.createFixture(fixtureDef);
		body.setType(bodyType);
	}

	public function addCentralForce(force:Vector2) {
		body.applyForce(B2Vec2.make(force.x, force.y),body.getPosition());
	}

	public function getIsAttachedToWorld() {
		return world != null;
	}

	public function compareBody(value:B2Body) {
		return value == body;
	}

	public function getB2Body() {
		return body;
	}

	override function onAdded(entity:Entity) {
		transformRef = entity.getComponent(Transform);
		setShape(entity.getComponent(Collider2D).getShape());
	}

	public function getPosition():Vector2 {
		if (!getIsAttachedToWorld())
			return Vector2.zero();
		var p = body.getPosition();
		return new Vector2(p.x, p.y);
	}

	public function getLinearVelocity() {
		var v = body.getLinearVelocity();
		return new Vector2(v.x, v.y);
	}

	public function getGravityScale() {
		return bodyDef.gravityScale;
	}

	public function setGravityScale(value:Float) {
		if (body == null) {
			bodyDef.gravityScale = value;
		} else
			body.setGravityScale(value);
	}

	public function setLinearVelocity(value:Vector2) {
		body.setLinearVelocity(B2Vec2.make(value.x, value.y));
	}

	public function getShape() {
		return shape;
	}

	public function setShape(shape:CollisionShape) {
		fixtureDef.shape = shape.createB2DShape();
		this.shape = shape;
		if (getIsAttachedToWorld()) {
			body.createFixture(fixtureDef);
		}
	}

	public function setPosition(position:Vector2) {
		var conv = new B2Vec2(position.x, position.y);
		body.setPosition(conv);
	}

	public function getType() {
		return bodyType;
	}

	public function setType(value:B2BodyType) {
		bodyType = value;
		if (getIsAttachedToWorld()) {
			body.setType(bodyType);
		}
	}

	public function getAngle() {
		if (!getIsAttachedToWorld())
			return 0.0;
		return body.getAngle();
	}

	public function setAngle(value:Float) {
		return body.setAngle(value);
	}

	public function addCentralImpulse(impulse:Vector2) {
		var p = getPosition();
		body.applyImpulse(new B2Vec2(impulse.x, impulse.y), new B2Vec2(p.x, p.y));
	}

	public function addTorque(torque:Float) {
		body.applyTorque(torque);
	}

	public function addImpulse(impulse:Vector2, pos:Vector2) {
		var offset = Vector2.subtract(getPosition(), pos);
		body.applyImpulse(new B2Vec2(impulse.x, impulse.y), new B2Vec2(offset.x, offset.y));
	}

}
