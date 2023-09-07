package dreamengine.plugins.post_processing;

import kha.System;
import kha.Scaler;
import kha.Framebuffer;
import kha.Image;


class PostProcessStack{
    var effects = new Array<PostProcessEffect>();

    public function new(rest:Array<PostProcessEffect>){
        for (e in rest){
            effects.push(e);
        }
    }

	@:generic
	public function getEffect<T:PostProcessEffect>(t:Class<T>):T {
        for (e in effects){
			if (Std.isOfType(e, t)) {
				return cast e;
			}
        }
        return null;
    }

    public function render(img:Image, framebuffer:Framebuffer){
        var intermediate = Image.createRenderTarget(img.width, img.height, img.format);

        intermediate.g2.begin();
		Scaler.scale(img, intermediate, System.screenRotation);
        intermediate.g2.end();


        var lastImage :Image = intermediate;

        for(eff in effects){
            if (!eff.enabled) continue;
            var int2 = Image.createRenderTarget(img.width, img.height, img.format);
            eff.execute(lastImage, int2, img);
            lastImage.unload();
            lastImage = int2;
        }

        framebuffer.g2.begin();
		Scaler.scale(lastImage, framebuffer, System.screenRotation);
        framebuffer.g2.end();
        lastImage.unload();
    }
}