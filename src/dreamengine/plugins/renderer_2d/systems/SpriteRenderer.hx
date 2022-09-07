package dreamengine.plugins.renderer_2d.systems;

import dreamengine.device.Screen;
import dreamengine.core.Time;
import kha.math.Matrix3;
import dreamengine.plugins.renderer_2d.components.Camera;
import kha.math.FastMatrix3;
import dreamengine.core.math.Vector.Vector2i;
import dreamengine.core.math.Vector.Vector2;
import kha.Assets;
import kha.graphics2.Graphics;
import dreamengine.plugins.renderer_2d.components.Transform2D;
import dreamengine.plugins.renderer_2d.components.Sprite;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class SpriteRenderer extends System{
    public function render(ctx:SystemContext, params:Array<Any>){

        var graphics:Graphics = cast params[0];

        var transform:Transform2D = cast ctx.getComponent(Transform2D);
        var spr:Sprite = cast ctx.getComponent(Sprite);
        var cm:Camera = cast params[1];
        var image = spr.getImage();
        var ppu = spr.getPPU();

        if (image == null) return;

        var pos = transform.position;
        var scale = transform.scale;
        var ppuScale = image.width / ppu;
        trace('Scale with ppu: $ppuScale, total scale is ${scale.toString()}');
        scale = Vector2.multiply(scale,ppuScale);


        var vFlipMultiplier = spr.flip? -1 : 1;
    

        var pivotOffset = new Vector2(image.width * transform.pivot.x, image.height * transform.pivot.y);

        var actualPosition = new Vector2(pos.x - pivotOffset.x * scale.x, pos.y - pivotOffset.y * scale.y);


        graphics.pushRotation(transform.angle, actualPosition.x,actualPosition.y);
        graphics.drawScaledImage(image, actualPosition.x, actualPosition.y, image.width * scale.x * vFlipMultiplier, image.height * scale.y);
        graphics.popTransformation();
    }

    override function getTargetComponents():Array<Class<Component>> {
        return [Sprite, Transform2D];
    }
}