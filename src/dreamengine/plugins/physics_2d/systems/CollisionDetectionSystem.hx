package dreamengine.plugins.physics_2d.systems;

import dreamengine.plugins.physics_2d.components.Collision2D;
import dreamengine.plugins.physics_2d.components.Collision2D.Collision;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactListener;
import dreamengine.core.Engine;
import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.ecs.System;

class CollisionDetectionSystem extends System {
	var world:Physics2DWorld;
	var contactListener:Physics2DContactListener;

	override function onRegistered(engine:Engine) {
		contactListener = new Physics2DContactListener();

		world = engine.pluginContainer.getPlugin(Physics2D).getWorld();
		world.getB2World().setContactListener(contactListener);
	}

	override function onUnregistered(engine:Engine) {
		world.getB2World().setContactListener(null);
	}

	override function execute(ctx:ECSContext) {
		if (contactListener.contacts.length > 0) {
			for (c in ctx.filter([Collision2D])) {

            }
		}
	}
}

class Physics2DContactListener extends B2ContactListener {
	public var contacts = new Array<B2Contact>();

	override function beginContact(contact:B2Contact) {
		contacts.push(contact);
        trace("CONTACT");
	}

	override function endContact(contact:B2Contact) {
		contacts.remove(contact);
	}
}
