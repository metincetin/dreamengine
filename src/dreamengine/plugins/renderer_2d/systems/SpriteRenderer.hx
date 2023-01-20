package dreamengine.plugins.renderer_2d.systems;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.device.Screen;
import dreamengine.core.math.Vector.Vector3;
import dreamengine.core.math.Mathf;
import dreamengine.plugins.ecs.System.RenderContext;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.renderer_2d.components.Sprite;
import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.ecs.System.RenderSystem;



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
			var localPos = localRect.getPosition();
			
			
			var worldPosition = localPos.copy();
			worldPosition .x += position.x;
			worldPosition .y += position.y;
			

			var drawSize = localRect.getSize();
			drawSize.multiply(scale.asVector2());

			var camera = renderContext.getCamera();
			var viewMatrix = camera.getViewMatrix();
			var cameraPos = new Vector3(viewMatrix._30, viewMatrix._31);
			var cameraRight = new Vector3(viewMatrix._00, viewMatrix._01, viewMatrix._02);
			var screenRes = Screen.getResolution();
			
			 
			var drawPosition = worldPosition.copy();

			drawPosition.x -= cameraPos.x - screenRes.x * 0.5;
			drawPosition.y -= cameraPos.y - screenRes.y * 0.5;

			

			graphics.pushTranslation(drawPosition.x, drawPosition.y);
			
			graphics.pushRotation(rotation, drawPosition.x, drawPosition.y);
			//graphics.pushTranslation(-cameraPos.x + screenRes.x * 0.5, -cameraPos.y + screenRes.y * 0.5);
			
			
			graphics.pushRotation((Math.atan2(cameraRight.y, cameraRight.x)), screenRes.x * 0.5 + localPos.x, screenRes.y * 0.5 + localPos.y);
			
			graphics.drawScaledImage(image, localRect.getPosition().x, localRect.getPosition().y, drawSize.x, drawSize.y);
			
			graphics.popTransformation();
			graphics.popTransformation();
			graphics.popTransformation();
		}
	}
}
