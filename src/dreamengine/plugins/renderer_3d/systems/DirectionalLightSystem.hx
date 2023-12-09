package dreamengine.plugins.renderer_3d.systems;

import dreamengine.core.Engine;
import kha.math.FastMatrix4;
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
	var engine:Engine;

	override function onRegistered(engine:Engine) {
		this.engine = engine;
	}
	override function execute(ctx:ECSContext) {
		var filter = ctx.filter([Transform, DirectionalLight]);

		for (c in filter) {
			var tr:Transform = c.getComponent(Transform);
			var light:DirectionalLight = c.getComponent(DirectionalLight);

			var col = light.color;

			var fw = tr.getForward();


			ShaderGlobals.setFloat3("_DirectionalLightColor", new Vector3(col.R * light.intensity, col.G * light.intensity, col.B * light.intensity));
			ShaderGlobals.setFloat3("_DirectionalLightDirection", fw);
			ShaderGlobals.setMatrix("_LightSpaceMatrix", light.getViewProjectionMatrix());

			ShaderGlobals.setFloat("_DepthBias", 0.005);
			light.data.direction = fw;
			engine.getRenderer().addLight(
				light.data
			);
		}
	}

}
