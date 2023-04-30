package dreamengine.plugins.renderer_3d.systems;

import dreamengine.plugins.ecs.ECSContext;
import dreamengine.core.Time;
import dreamengine.core.math.Vector3;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.renderer_3d.components.Light;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import dreamengine.plugins.ecs.System;

class DirectionalLightSystem extends System {
	override function execute(ctx:ECSContext) {
		var filter = ctx.filter([Transform, DirectionalLight]);

		for (c in filter) {
			var tr:Transform = c.getComponent(Transform);
			var light:Light = c.getComponent(DirectionalLight);

			var fw = tr.getForward();
			var col = light.color;

			ShaderGlobals.setFloat3("directionalLightColor", new Vector3(col.R * light.intensity, col.G * light.intensity, col.B * light.intensity));
			ShaderGlobals.setFloat3("directionalLightDirection", fw);
		}
	}

}
