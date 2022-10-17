package dreamengine.plugins.renderer_2d.systems;

import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.core.math.Vector.Vector3;
import kha.graphics2.Graphics;
import dreamengine.plugins.renderer_2d.components.Sprite;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class SpriteRenderer extends RenderSystem {
	override function execute(ecsContext:ECSContext, renderContext:RenderContext) {
		for (c in ecsContext.filter([Sprite, Transform])) {
			var graphics = renderContext.getRenderTarget().g2;

			var transform = c.getComponent(Transform);

			var spr = c.getComponent(Sprite);

			var image = spr.getImage();
			var ppu = spr.getPPU();

			if (image == null)
				return;

			var drawRect = spr.getDrawRect(transform);
			// graphics.pushRotation(transform.angle, actualPosition.x, actualPosition.y);
			// graphics.drawImage(image, 0, 0);

			// graphics.drawRect(actualPosition.x, actualPosition.y, 100, 32);
			graphics.drawScaledImage(image, drawRect.position.x, drawRect.position.y, drawRect.size.x, drawRect.size.y);
			// graphics.popTransformation();
		}
	}
}
