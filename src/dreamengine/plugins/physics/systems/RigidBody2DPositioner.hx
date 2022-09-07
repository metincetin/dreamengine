package dreamengine.plugins.physics.systems;

import dreamengine.plugins.renderer_2d.components.Transform2D;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class RigidBody2DPositioner extends System {
	override function execute(ctx:SystemContext) {
		var rb:RigidBody2D = cast ctx.getComponent(RigidBody2D);
		var tr:Transform2D = cast ctx.getComponent(Transform2D);
		var rbPosition = rb.getPosition();
		var rbAngle = rb.getAngle();

		tr.position = rbPosition;
		tr.angle = rbAngle;
	}

	override function getTargetComponents():Array<Class<Component>> {
		return [Transform2D, RigidBody2D];
	}
}
