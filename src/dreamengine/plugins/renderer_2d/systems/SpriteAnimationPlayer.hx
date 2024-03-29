package dreamengine.plugins.renderer_2d.systems;

import dreamengine.plugins.renderer_2d.components.SpritesheetAnimatedSprite;
import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.renderer_2d.components.AnimatedSprite;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class SpriteAnimationPlayer extends System {
	override function execute(ecsContext:ECSContext) {
		for (c in ecsContext.query([new Optional(AnimatedSprite), new Optional(SpritesheetAnimatedSprite)])) {
			var spr:AnimatedSprite = cast c.getComponent(AnimatedSprite);
			if (spr != null){
				if (spr.getIsPlaying())
					spr.update();
				continue;
			}
			var sheetSpr:SpritesheetAnimatedSprite = cast c.getComponent(SpritesheetAnimatedSprite);
			if (sheetSpr != null){
				if (sheetSpr.getIsPlaying())
					sheetSpr.update();
				continue;

			}
		}
	}
}
