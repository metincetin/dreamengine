package dreamengine.plugins.post_processing.effects;

import kha.graphics4.PipelineState;
import kha.Scaler;
import kha.Image;
import kha.Shaders;
import kha.graphics4.FragmentShader;

class Blur extends PostProcessEffect {
    override function createPasses():Array<PostProcessEffectPass> {
        return [new HorizontalBlurPass(), new VerticalBlurPass()];
    }
}

class HorizontalBlurPass extends PostProcessEffectPass{
    override function getShader():FragmentShader {
        return Shaders.blur_horizontal_frag;
    }
}

class VerticalBlurPass extends PostProcessEffectPass{
    override function getShader():FragmentShader {
        return Shaders.blur_vertical_frag;
    }
}
