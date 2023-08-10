package dreamengine.plugins.renderer_2d.systems;

import kha.math.FastMatrix3;
import dreamengine.core.math.Vector3;
import dreamengine.plugins.renderer_2d.components.Line2D;
import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.ecs.System.RenderContext;
import dreamengine.plugins.ecs.System.RenderSystem;

class LineRenderer2D extends RenderSystem {
	override function execute(ecsContext:ECSContext, renderContext:RenderContext) {
		var g2 = renderContext.getRenderTarget().g2;

		var filter = ecsContext.filter([Line2D]);
		for (f in filter) {
			var line = f.getComponent(Line2D);
			for (i in 0...line.length() - 1) {
				var p1 = line.getPosition(i);
				var p2 = line.getPosition(i + 1);

				var camera = renderContext.getCamera();
				var viewMatrix = camera.getViewMatrix();
				var cameraPos = new Vector3(viewMatrix._30, viewMatrix._31);
				var cameraRight = new Vector3(viewMatrix._00, viewMatrix._01, viewMatrix._02);
				var screenRes = dreamengine.device.Screen.getResolution();
				var cameraSize = renderContext.getCamera().size;

				var s = 1 / (cameraSize);

				g2.transformation = FastMatrix3.identity();

				g2.scale(s, s);
				//g2.rotate(rotation, 0, 0);
				g2.translate(screenRes.x * 0.5, screenRes.y * 0.5);
				g2.translate(-cameraPos.x, -cameraPos.y);

				// g2.translate(position.x * (200) * s, position.y * 200 * s);
                p1 *= s * 200;
                p2 *= s * 200;
			    g2.rotate(-Math.atan2(cameraRight.y, cameraRight.x),cameraPos.x + screenRes.x * 0.5,cameraPos.y + screenRes.y * 0.5);
				g2.drawLine(p1.x, p1.y, p2.x, p2.y, 10);
			}
		}
	}
}
