package dreamengine.plugins.renderer_3d.systems;

import dreamengine.plugins.renderer_3d.components.Mesh;
import dreamengine.core.math.Rect;
import dreamengine.plugins.imgui.IMGUI;
import dreamengine.plugins.renderer_3d.components.Light;
import dreamengine.core.math.Vector.Vector3;
import dreamengine.plugins.ecs.Component;
import dreamengine.core.Time;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.ecs.System;

class Rotator extends System {
	override function execute(ctx:SystemContext) {
		var transform:Transform = cast ctx.getComponent(Transform);
		transform.rotate(Vector3.right(), Time.getDeltaTime());
	}

	override function getTargetComponents():Array<Class<Component>> {
		return [Transform, Mesh];
	}
}
