package dreamengine.plugins.renderer_2d.systems;

import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.renderer_2d.components.AnimatedSprite;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class SpriteAnimationPlayer extends System {
	override function execute(ecsContext:ECSContext) {
		for (c in ecsContext.filter([AnimatedSprite])) {
			var spr:AnimatedSprite = cast c.getComponent(AnimatedSprite);
			if (spr.getIsPlaying())
				spr.update();
		}
	}
}
