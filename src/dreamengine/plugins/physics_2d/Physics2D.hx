package dreamengine.plugins.physics_2d;

import box2D.common.B2Settings;
import dreamengine.plugins.physics_2d.systems.CollisionDetectionSystem;
import box2D.dynamics.B2World;
import box2D.dynamics.B2BodyType;
import box2D.dynamics.B2World;
import box2D.common.math.*;
import dreamengine.plugins.physics_2d.systems.RigidBody2DTransformSync;
import dreamengine.plugins.physics_2d.components.*;
import dreamengine.plugins.ecs.ECS;
import dreamengine.core.Engine;
import dreamengine.core.Time;
import dreamengine.core.Plugin.IPlugin;

class Physics2D implements IPlugin {
	var ecs:ECS;
	var engine:Engine;

	var world:Physics2DWorld;

	public function new() {}

	public function initialize(engine:Engine) {
		ecs = engine.pluginContainer.getPlugin(ECS);

		world = new Physics2DWorld(new B2World(new B2Vec2(0, 9.81), true));
		engine.createTimeTask(physicsLoop, 0.02);


		ecs.registerSystem(new RigidBody2DTransformSync());
		ecs.registerSystem(new CollisionDetectionSystem());
	}

	public function getWorld():Physics2DWorld {
		return world;
	}

	public function finalize() {
	}

	function physicsLoop() {
		world.step(Time.getDeltaTime(), 12, 12);
	}

	public function getName():String {
		return "physics_2d";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [ECS];
	}

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
		return new ECS();
	}
}
