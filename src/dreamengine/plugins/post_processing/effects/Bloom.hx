package dreamengine.plugins.post_processing.effects;

import kha.Image;
import kha.graphics4.FragmentShader;
import dreamengine.plugins.post_processing.effects.Blur.VerticalBlurPass;
import dreamengine.plugins.post_processing.effects.Blur.HorizontalBlurPass;
import kha.Shaders;

class Bloom extends PostProcessEffect{
    override function createPasses():Array<PostProcessEffectPass> {
        return [new BloomFilterPass(), 
            new HorizontalBlurPass(), 
            new HorizontalBlurPass(), 
            new HorizontalBlurPass(), 
            new HorizontalBlurPass(), 
            new HorizontalBlurPass(), 
            new HorizontalBlurPass(), 
            new VerticalBlurPass(),
            new VerticalBlurPass(),
            new VerticalBlurPass(),
            new VerticalBlurPass(),
            new VerticalBlurPass(),
            new VerticalBlurPass(),
            new SimplePostProcessPass(Shaders.screen_apply_frag)
        ];
    }
}


class BloomFilterPass extends PostProcessEffectPass{
    override function getShader():FragmentShader {
        return kha.Shaders.intensity_filter_frag;
    }
    /*override function createRenderTarget(source:Image):Image {
        return Image.createRenderTarget(cast source.width / 4, cast source.height / 4, source.format);
    }*/
}