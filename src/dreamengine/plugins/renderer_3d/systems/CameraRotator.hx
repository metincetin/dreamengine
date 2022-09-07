package dreamengine.plugins.renderer_3d.systems;

import dreamengine.core.math.Rect;
import dreamengine.plugins.imgui.IMGUI;
import dreamengine.core.math.Vector.Vector3;
import dreamengine.core.Time;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System.SystemContext;

class CameraRotator extends dreamengine.plugins.ecs.System {
	override function execute(ctx:SystemContext) {
		var tr:Transform = cast ctx.getComponent(Transform);
		tr.rotate(Vector3.right(), Time.getDeltaTime() * 40);

		// IMGUI.box(Rect.create(Time.getCurrentTime() * 5, 0, 128, 32));
		IMGUI.text(Rect.create(0, 32, 0, 0), 'Cam Forward: ${Std.string(tr.getForward())}');
		IMGUI.text(Rect.create(0, 64, 0, 0), 'Cam Up: ${Std.string(tr.getUp())}');
		IMGUI.text(Rect.create(0, 96, 0, 0), 'Cam Right: ${Std.string(tr.getRight())}');
	}

	override function getTargetComponents():Array<Class<Component>> {
		return [Camera, Transform];
	}
}
