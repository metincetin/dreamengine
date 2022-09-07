package dreamengine.plugins.physics;

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

class RigidBody2D extends Component{
    public var bodyType: B2BodyType;
    
    var bodyDef:B2BodyDef;
    var fixtureDef:B2FixtureDef;


    var body:B2Body;
    var world:B2World;


    public function new(world:B2World){
        super();
        bodyDef = new B2BodyDef();
        fixtureDef = new B2FixtureDef();
        fixtureDef.restitution = .7;
        fixtureDef.friction = 0.3;
        fixtureDef.density = 1;
        bodyDef.angularDamping = 0;
        


        body = world.createBody(bodyDef);

        body.applyTorque(75);
    }

    public function getPosition():Vector2{
        var p = body.getPosition();
        return new Vector2(p.x, p.y);
    }

    public function getLinearVelocity(){
        return body.getLinearVelocity();
    }
    public function setLinearVelocity(value:Vector2){
        body.setLinearVelocity(B2Vec2.make(value.x, value.y));
    }

    public function getShape(){
        return fixtureDef.shape;
    }

    public function setShape(shape:B2Shape){
        fixtureDef.shape = shape;
        body.createFixture(fixtureDef);
    }

    public function setPosition(position:Vector2){
        var conv = new B2Vec2(position.x, position.y);
        body.setPosition(conv);
    }
    public function getType(){
        return bodyDef.type;
    }
    public function setType(value:B2BodyType){
        body.setType(value);
    }
    public function getAngle(){
        return body.getAngle();
    }
    public function setAngle(value:Float){
        return body.setAngle(value);
    }

    public function addCentralImpulse(impulse:Vector2){
        var p = getPosition();
        body.applyImpulse(new B2Vec2(impulse.x, impulse.y), new B2Vec2(p.x, p.y));
    }

    public function addImpulse(impulse:Vector2, pos:Vector2){
        var offset = Vector2.subtract(getPosition(), pos);
        body.applyImpulse(new B2Vec2(impulse.x, impulse.y), new B2Vec2(offset.x, offset.y));
    }
}