package dreamengine.plugins.post_processing.effects;

import dreamengine.plugins.post_processing.effects.Blur.KawaseBlurPass;
import kha.Shaders;
import dreamengine.plugins.post_processing.passes.RadialBlur;
import kha.graphics4.TextureUnit;
import dreamengine.plugins.renderer_base.components.Camera;
import kha.Image;

class Godrays extends PostProcessEffect {
	var depthUnit:TextureUnit;

	override function createPasses():Array<PostProcessEffectPass> {
		var pass = new SimplePostProcessPass(kha.Shaders.godrays_frag);
		var pipeline = pass.getPipeline();
		depthUnit = pipeline.getTextureUnit("u_depthMap");
		return [
			pass,
			new RadialBlur(32, true, 16),
			//new RadialBlur(32, true, 1),
            //new SimplePostProcessPass(Shaders.additive_blend_frag)
		]; 
	}

	override function sendValues(destination:Image, camera:Camera) {
		destination.g4.setTexture(depthUnit, camera.depthTexture);
	}
}
