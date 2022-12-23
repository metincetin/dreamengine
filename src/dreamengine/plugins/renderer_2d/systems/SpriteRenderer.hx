package dreamengine.plugins.renderer_2d.systems;

import dreamengine.plugins.renderer_base.ActiveCamera;
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

			var camera = renderContext.getCamera();
			var viewMatrix = camera.getViewMatrix();
			var cameraPos = new Vector3(viewMatrix._30, viewMatrix._31);
			var cameraUp = new Vector3(viewMatrix._10, viewMatrix._11, viewMatrix._12);
			var cameraForward = new Vector3(viewMatrix._20, viewMatrix._21, viewMatrix._22);
			graphics.pushTranslation(position.x, position.y);
			graphics.pushRotation(Mathf.radToDeg(rotation), position.x,position.y);
			graphics.pushRotation(roll, cameraPos.x, cameraPos.y);
			graphics.pushTranslation(cameraPos.x, cameraPos.y);
			graphics.drawScaledImage(image, drawRect.position.x, drawRect.position.y, drawRect.size.x, drawRect.size.y);
			graphics.popTransformation();
			graphics.popTransformation();
			graphics.popTransformation();
			graphics.popTransformation();
		}
	}
}
