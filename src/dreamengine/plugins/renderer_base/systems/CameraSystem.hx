package dreamengine.plugins.renderer_base.systems;

import dreamengine.core.Engine;
import dreamengine.plugins.ecs.ECSContext;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class CameraSystem extends System {

	var engine:Engine;

	override function onRegistered(engine:Engine) {
		this.engine = engine;
	}

	override function execute(ctx:ECSContext) {
		for (c in ctx.filter([Camera, Transform])) {
			var camera:Camera = cast c.getComponent(Camera);
			var transform:Transform = cast c.getComponent(Transform);
			var pos = transform.getPosition();
			var euler = transform.getRotation().toEuler();
			var fw = transform.getForward();
			var up = transform.getUp().scaled(-1);
			var right = transform.getRight();

			/*var view = new FastMatrix4(
				right.x,	up.x,	fw.x,	pos.x,
				right.y,	up.y, 	fw.y,	pos.y,
				right.z,	up.z,	fw.z, 	pos.z,
				0,0,0,1
			);*/


			var view = FastMatrix4.lookAt(pos, pos + fw, up);


			ShaderGlobals.setFloat3("_CameraPosition", pos);

			camera.setViewMatrix(view);
			camera.setViewProjectionMatrix(camera.getProjectionMatrix().multmat(view));

			engine.getRenderer().setCamera(camera);
		}
	}
}
