package dreamengine.plugins.physics_2d;

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
		engine.registerLoopEvent(gameLoop);

		ecs.registerSystem(new RigidBody2DTransformSync());
		ecs.registerSystem(new CollisionDetectionSystem());
	}

	public function getWorld():Physics2DWorld {
		return world;
	}

	public function finalize() {
		engine.unregisterLoopEvent(gameLoop);
	}

	function gameLoop() {
		world.step(Time.getDeltaTime(), 3, 3);
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
