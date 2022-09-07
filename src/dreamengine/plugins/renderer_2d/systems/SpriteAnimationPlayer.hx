package dreamengine.plugins.renderer_2d.systems;

import dreamengine.plugins.renderer_2d.components.AnimatedSprite;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class SpriteAnimationPlayer extends System{
    override function execute(ctx:SystemContext) {
        var spr:AnimatedSprite = cast ctx.getComponent(AnimatedSprite);
        if (spr.getIsPlaying())
            spr.update();
    }
    override function getTargetComponents():Array<Class<Component>> {
        return [AnimatedSprite];
    }
}