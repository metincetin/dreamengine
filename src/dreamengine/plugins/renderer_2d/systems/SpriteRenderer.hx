package dreamengine.plugins.renderer_2d.systems;



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
			var cameraRight = new Vector3(viewMatrix._00, viewMatrix._01, viewMatrix._02);
			var screenRes = Screen.getResolution();

			graphics.pushTranslation(position.x, position.y);
			graphics.pushRotation(rotation, position.x, position.y);

			graphics.pushTranslation(-cameraPos.x + screenRes.x * 0.5, -cameraPos.y + screenRes.y * 0.5);graphics.pushRotation(rotation, position.x, position.y);
			graphics.pushRotation((Math.atan2(cameraRight.y, cameraRight.x)), cameraPos.x + screenRes.x * 0.5, cameraPos.y + screenRes.y * 0.5);

			
			graphics.drawScaledImage(image, drawRect.position.x, drawRect.position.y, drawRect.size.x, drawRect.size.y);
			
			graphics.popTransformation();
			graphics.popTransformation();
			graphics.popTransformation();
			graphics.popTransformation();
		}
	}
}
