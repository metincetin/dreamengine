package dreamengine.plugins.renderer_base.systems;

import dreamengine.plugins.ecs.ECSContext;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class CameraSystem extends System {
	override function execute(ctx:ECSContext) {
		for (c in ctx.filter([Camera, Transform])) {
			var camera:Camera = cast c.getComponent(Camera);
			var transform:Transform = cast c.getComponent(Transform);
			var pos = transform.getPosition();
			var euler = transform.getRotation().toEuler();
			var fw = transform.getForward();
			var up = transform.getUp();
			var right = transform.getRight();

			var view = new FastMatrix4(
				right.x,	up.x,	fw.x,	pos.x,
				right.y,	-up.y, 	fw.y,	pos.y,
				right.z,	up.z,	-fw.z, 	pos.z,
				0,0,0,1
			);

			camera.setViewMatrix(view);
			ShaderGlobals.setFloat3("cameraPosition", pos);
		}
	}
}
