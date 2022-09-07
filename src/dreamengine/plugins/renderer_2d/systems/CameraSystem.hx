package dreamengine.plugins.renderer_2d.systems;

import dreamengine.plugins.renderer_2d.components.Transform2D;
import dreamengine.plugins.renderer_2d.components.Camera;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class CameraSystem extends System{
    override function execute(ctx:SystemContext) {
        var cm:Camera = cast ctx.getComponent(Camera);
        var tr:Transform2D = cast ctx.getComponent(Transform2D);
        cm.setZoom(tr.scale);
        cm.setOffset(tr.position);
        cm.setAngle(tr.angle);
    }

    override function getTargetComponents():Array<Class<Component>> {
        return [Camera, Transform2D];
    }
}