package dreamengine.plugins.renderer_2d.systems;

import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.core.math.Vector.Vector3;
import kha.graphics2.Graphics;
import dreamengine.plugins.renderer_2d.components.Sprite;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class SpriteRenderer extends RenderSystem {
	override function execute(ctx:RenderContext) {
		super.execute(ctx);
		var graphics = ctx.getFramebuffer().g2;

		var transform = ctx.getComponent(Transform);

		var spr = ctx.getComponent(Sprite);

		var image = spr.getImage();
		var ppu = spr.getPPU();

		if (image == null)
			return;

		var pos = transform.getPosition();
		var scale = transform.getScale();
		var ppuScale = image.width / ppu * 0.1;
		trace('Scale with ppu: $ppuScale, total scale is ${scale.toString()}');
		scale = Vector3.multiply(scale, ppuScale);

		var vFlipMultiplier = spr.flip ? -1 : 1;

		// do pivot here
		var pivotOffset = new Vector3(image.width * 0.5, image.height * 0.5);

		var actualPosition = new Vector3(pos.x - pivotOffset.x * scale.x, pos.y - pivotOffset.y * scale.y);

		// graphics.pushRotation(transform.angle, actualPosition.x, actualPosition.y);
		// graphics.drawImage(image, 0, 0);
		graphics.drawScaledImage(image, actualPosition.x, actualPosition.y, image.width * scale.x * vFlipMultiplier, image.height * scale.y);
		// graphics.popTransformation();
	}

	override function getTargetComponents():Array<Class<Component>> {
		return [Sprite, Transform];
	}
}
