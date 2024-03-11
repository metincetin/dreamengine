package dreamengine.plugins.renderer_2d.systems;

import kha.math.FastMatrix4;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.core.Renderer;
import dreamengine.core.Engine;
import dreamengine.plugins.renderer_2d.components.Sprite;
import dreamengine.plugins.ecs.ECSContext;
import dreamengine.plugins.ecs.System;

class SpriteRenderer extends System {
	var renderer:Renderer;

	override function onRegistered(engine:Engine) {
		super.onRegistered(engine);
		renderer = engine.getRenderer();
	}
	override function execute(ecsContext:ECSContext) {
		var f = ecsContext.filter([Sprite, Transform]);

		for (e in f) {
			var sprite = e.getComponent(Sprite);
			var tr = e.getComponent(Transform);

			var position = tr.getPosition();
			var rotation = tr.getRotation();
			var scale = tr.getScale();

			var trMatrix = FastMatrix4.translation(position.x, position.y, position.z);
			var rotMatrix = rotation.toMatrix();
			var scaleMatrix = FastMatrix4.scale(scale.x, scale.y, scale.z);
			var ppuScale = sprite.getPPUScale() * sprite.getSpriteSize();
			var ppuScaleMatrix = FastMatrix4.scale(ppuScale.x, ppuScale.y, 1);

			sprite.getRenderable().modelMatrix = trMatrix.multmat(ppuScaleMatrix).multmat(rotMatrix).multmat(scaleMatrix);

			renderer.addTransparent(sprite.getRenderable());
		}
	}
}
