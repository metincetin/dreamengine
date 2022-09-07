package dreamengine.plugins.renderer_2d.systems;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.input.InputPlugin;
import dreamengine.plugins.renderer_2d.components.Transform2D;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class MouseLook extends System{
 
    var input:InputPlugin;

    public function new (input:InputPlugin){
        super();
        this.input = input;
    }

    override function execute(ctx:SystemContext) {
        var transform:Transform2D = cast ctx.getComponent(Transform2D);
        var pos = transform.position.copy();
        var mousePos = input.getInputHandler().getMouse(0).getPointerPosition();
        var dir = Vector2.subtract(mousePos.asVector2(),pos);
        dir.normalize();

        var angle = Math.atan2(dir.y, dir.x);

        transform.angle = angle;
    }

    override function getTargetComponents():Array<Class<Component>> {
        return [Transform2D];
    }
}