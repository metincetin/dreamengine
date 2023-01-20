package dreamengine.plugins.physics_2d;

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
	var world:B2World;

	public function new() {}

	public function initialize(engine:Engine) {
		ecs = engine.pluginContainer.getPlugin(ECS);

		world = new B2World(new B2Vec2(0, 9.81), true);
		engine.registerLoopEvent(gameLoop);

		ecs.registerSystem(new RigidBody2DTransformSync());
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

	public function createBodyComponent(bodyType:B2BodyType) {
		var rb = new RigidBody2D(world);
		rb.setType(bodyType);
		return rb;
	}
}
