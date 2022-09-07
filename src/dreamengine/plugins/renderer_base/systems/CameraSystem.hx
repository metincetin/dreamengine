package dreamengine.plugins.renderer_base.systems;

import kha.math.FastVector3;
import kha.math.FastMatrix4;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class CameraSystem extends System {
	override function execute(ctx:SystemContext) {
		var camera:Camera = cast ctx.getComponent(Camera);
		var transform:Transform = cast ctx.getComponent(Transform);
		var pos = transform.getPosition();
		var fw = transform.getForward();
		var up = transform.getUp();
		camera.setViewMatrix(FastMatrix4.lookAt(new FastVector3(pos.x, pos.y, pos.z), new FastVector3(fw.x, fw.y, fw.z), new FastVector3(up.x, up.y, up.z)));
	}

	override function getTargetComponents():Array<Class<Component>> {
		return [Camera, Transform];
	}
}
