package dreamengine.plugins.physics_2d.systems;

import dreamengine.plugins.physics_2d.components.RigidBody2D;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.ecs.System;
import dreamengine.core.math.Vector.Vector3;

class RigidBody2DTransformSync extends System{
    override function execute(ctx:ECSContext) {
        for(c in ctx.filter([Transform, RigidBody2D])){
            var tr = c.getComponent(Transform);
            var rb = c.getComponent(RigidBody2D);

            var rbPosition = rb.getPosition();
            var rbAngle = rb.getAngle();
            tr.setPosition(rbPosition.asVector3());
            tr.setEulerAngles(new Vector3(0,0,rbAngle));
        }
    }
}