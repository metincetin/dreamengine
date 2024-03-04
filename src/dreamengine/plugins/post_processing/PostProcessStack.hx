package dreamengine.plugins.post_processing;

import dreamengine.plugins.renderer_base.components.Camera;
import kha.graphics5_.TextureFormat;
import kha.System;
import kha.Scaler;
import kha.Framebuffer;
import kha.Image;


class PostProcessStack{
    var effects = new Array<PostProcessEffect>();

    var intermediate: Image;
    var effectIntermediate: Image;

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

    public function render(camera:Camera){
        var screenTexture = camera.renderTexture;
        if (intermediate == null){
            intermediate = Image.createRenderTarget(screenTexture.width, screenTexture.height, TextureFormat.RGBA64);
        }
        if (effectIntermediate == null){
            effectIntermediate = Image.createRenderTarget(screenTexture.width, screenTexture.height, TextureFormat.RGBA64);
        }
        intermediate.g2.begin();
        kha.Scaler.scale(screenTexture, intermediate, System.screenRotation);
        intermediate.g2.end();
        for(eff in effects){
            if (!eff.enabled) continue;
            eff.execute(intermediate, effectIntermediate, screenTexture, camera);

			intermediate.g2.begin();
			Scaler.scale(effectIntermediate, intermediate, kha.System.screenRotation);
			intermediate.g2.end();

        }


        screenTexture.g2.begin();
        kha.Scaler.scale(intermediate, screenTexture, kha.System.screenRotation);
        screenTexture.g2.end();
    }
}