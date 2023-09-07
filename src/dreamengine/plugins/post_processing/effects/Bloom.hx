package dreamengine.plugins.post_processing.effects;

import kha.graphics5_.TextureFormat;
import dreamengine.plugins.post_processing.effects.Blur.KawaseBlurPass;
import kha.Image;
import kha.graphics4.FragmentShader;
import dreamengine.plugins.post_processing.effects.Blur.VerticalBlurPass;
import dreamengine.plugins.post_processing.effects.Blur.HorizontalBlurPass;
import kha.Shaders;

class Bloom extends PostProcessEffect {
    var downsample = 1;

	public function new(downsample:Int = 1) {
        super();
        this.downsample = downsample;
    }

	override function createPasses():Array<PostProcessEffectPass> {
		return [
            new DownsamplePass(downsample),
			new BloomFilterPass(),
			new KawaseBlurPass(1.5),
			new KawaseBlurPass(2.5),
			new KawaseBlurPass(3.5),
			new KawaseBlurPass(4.5),
			new KawaseBlurPass(5.5),
			new KawaseBlurPass(6.5),
			new KawaseBlurPass(7.5),
			new KawaseBlurPass(8.5),
			new SimplePostProcessPass(Shaders.combine_frag),
		];
	}

}

class BloomFilterPass extends PostProcessEffectPass {
	override function getShader():FragmentShader {
		return kha.Shaders.intensity_filter_frag;
	}
	/*override function createRenderTarget(source:Image):Image {
		return Image.createRenderTarget(cast source.width / 4, cast source.height / 4, source.format);
	}*/
}

class DownsamplePass extends PostProcessEffectPass{
    var downsample = 1;
    public function new(downsample = 1){
        super();
        this.downsample = downsample;
    }
    override function createRenderTarget(source:Image):Image {
        return Image.createRenderTarget(cast source.width / downsample, cast source.height / downsample, source.format);
    }
}