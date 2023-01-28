package dreamengine.plugins.physics_2d.systems;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.core.Engine;
import dreamengine.plugins.physics_2d.components.RigidBody2D;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.ecs.System;
import dreamengine.core.math.Vector.Vector3;

class RigidBody2DTransformSync extends System{
    
    var world:Physics2DWorld;

    override function onRegistered(engine:Engine) {
        world = engine.pluginContainer.getPlugin(Physics2D).getWorld();
    }

    override function execute(ctx:ECSContext) {
        for(c in ctx.filter([Transform, RigidBody2D])){
            var tr = c.getComponent(Transform);
            var rb = c.getComponent(RigidBody2D);

            if (!rb.getIsAttachedToWorld()){
                rb.setWorld(world);
            }

            var rbPosition = rb.getPosition();
            var rbAngle = rb.getAngle();
            tr.setPosition(rbPosition.asVector3());
            tr.setEulerAngles(new Vector3(0,0,rbAngle));
        }
    }
}