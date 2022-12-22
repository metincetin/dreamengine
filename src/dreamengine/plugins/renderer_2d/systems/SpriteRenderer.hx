package dreamengine.plugins.renderer_2d.systems;

import dreamengine.core.math.Mathf;
import kha.math.FastMatrix3;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.core.math.Rect;
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
			var position = transform.getPosition();
			var rotation = Mathf.degToRad(transform.getRotation().toEuler().z);
			var scale = transform.getScale();

			var spr = c.getComponent(Sprite);

			var image = spr.getImage();
			var ppu = spr.getPPU();

			if (image == null)
				return;

			var localRect = spr.getLocalRect();
			var drawRect = new Rect();
			drawRect.position = localRect.position;

			drawRect.size = localRect.size;
			drawRect.size.multiply(scale.asVector2());

			graphics.pushTranslation(position.x, position.y);
			graphics.pushRotation(rotation, position.x,position.y);
			graphics.drawScaledImage(image, drawRect.position.x, drawRect.position.y, drawRect.size.x, drawRect.size.y);
			graphics.popTransformation();
			graphics.popTransformation();
		}
	}
}
