package dreamengine.plugins.physics;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.physics.systems.RigidBody2DPositioner;
import dreamengine.core.Time;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2World;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;
import dreamengine.plugins.ecs.*;

class PhysicsEnginePlugin implements IPlugin{
	var world:B2World;

	public function new(){}
	public function initialize(engine:Engine){
		world = new B2World (new B2Vec2(0, 9.81), true);
		engine.registerLoopEvent(gameLoop);
		
		var ecsResult = engine.pluginContainer.getPlugin("ecs");
		switch(ecsResult){
			case Some(v):
				var ecs:ECS = cast v;
				ecs.registerSystem(new RigidBody2DPositioner());
			case None: throw("ECS not found");
		}

		trace(world);
	}
	public function setGravity(gravity:Vector2){
		world.setGravity(B2Vec2.make(gravity.x, gravity.y));
	}

	public function createBodyComponent(){
		return new RigidBody2D(world);
	}

	public function finalize(){

	}

	function gameLoop(){
		world.step(Time.getDeltaTime(), 3, 3);
	}

	public function getName(){
		return "physics";
	}
	public function getDependentPlugins():Array<Class<IPlugin>>{
		return [ECS];
	}
	public function handleDependency(ofType:Class<IPlugin>):IPlugin{
		return null;
	}
}