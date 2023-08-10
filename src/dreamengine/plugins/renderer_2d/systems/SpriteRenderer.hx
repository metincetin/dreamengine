package dreamengine.plugins.renderer_2d.systems;

import dreamengine.core.math.Quaternion;
import kha.Color;
import dreamengine.core.Time;
import kha.math.FastMatrix2;
import kha.math.FastVector2;
import dreamengine.plugins.dreamui.containers.ScreenContainer;
import kha.math.FastMatrix4;
import kha.math.FastVector4;
import kha.math.FastMatrix3;
import dreamengine.core.math.Vector2;
import dreamengine.device.Screen;
import dreamengine.core.math.Vector3;
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
			var pivot = spr.pivot;

			var image = spr.getImage();

			if (image == null)
				return;

			var localRect = spr.getLocalRect();
			var localPos = localRect.getPosition() * scale.asVector2();
			var localSize = localRect.getSize() * scale;
			var ppuScale = spr.getPPU() / 100;

			var camera = renderContext.getCamera();
			var viewMatrix = camera.getViewMatrix();
			var cameraPos = new Vector3(viewMatrix._30, viewMatrix._31);
			var cameraRight = new Vector3(viewMatrix._00, viewMatrix._01, viewMatrix._02);
			var screenRes = Screen.getResolution();
			var cameraSize = renderContext.getCamera().size;

			var s = 1 / (cameraSize);

			graphics.transformation = FastMatrix3.identity();

			graphics.scale(s, s);
			graphics.rotate(rotation, 0, 0);
			graphics.translate(screenRes.x * 0.5, screenRes.y * 0.5);
			graphics.translate(-cameraPos.x, -cameraPos.y);

			graphics.translate(position.x * (200) * s, position.y * 200 * s);

			graphics.rotate(-Math.atan2(cameraRight.y, cameraRight.x), cameraPos.x + screenRes.x * 0.5, cameraPos.y + screenRes.y * 0.5);

			graphics.drawScaledImage(image, localPos.x, localPos.y, localSize.x, localSize.y);
			#if debug
			graphics.drawRect(localPos.x, localPos.y, localSize.x, localSize.y, cameraSize);
			#end
		}
	}
}
