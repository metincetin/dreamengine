package dreamengine.plugins.renderer_2d.systems;

import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.renderer_2d.components.ParticleEmitter;
import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.ecs.System;

class ParticleRenderer extends System{
	override function execute(ecsContext:ECSContext) {
		for (res in ecsContext.filter([Transform, ParticleEmitter])) {
			var emitter = res.getComponent(ParticleEmitter);
			//emitter.update(res.getComponent(Transform), renderContext.getRenderTarget().g2);
		}
	}
}
