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


			var pos = tr.getPosition();
			var fw = tr.getForward();
			var up = tr.getUp();
			var right = tr.getRight();


			ShaderGlobals.setFloat3("directionalLightColor", new Vector3(col.R * light.intensity, col.G * light.intensity, col.B * light.intensity));
			ShaderGlobals.setFloat3("directionalLightDirection", fw);
			ShaderGlobals.setTexture("shadowMap", light.getRenderTarget());
			ShaderGlobals.setFloat("depthBias", 0.005);
			engine.getRenderer().addLight(light);
		}
	}

}
