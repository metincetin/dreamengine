package dreamengine.plugins.renderer_3d.systems;

import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.renderer_3d.components.PointLight;
import dreamengine.core.Time;
import dreamengine.core.math.Vector3;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.renderer_3d.components.Light;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import dreamengine.plugins.ecs.System;

class PointLightSystem extends System {
	override function execute(ctx:ECSContext) {
		var filter = ctx.filter([PointLight, Transform]);

		for (c in filter) {
			var tr:Transform = c.getComponent(Transform);
			var light:PointLight = c.getComponent(PointLight);

			var fw = tr.getForward();
			var col = light.color;

			ShaderGlobals.setFloat3("additionalLight0_color", new Vector3(col.R * light.intensity, col.G * light.intensity, col.B * light.intensity));
			ShaderGlobals.setFloat("additionalLight0_attenuation", light.radius);
			ShaderGlobals.setFloat3("additionalLight0_position", tr.getPosition());
		}
	}
}
