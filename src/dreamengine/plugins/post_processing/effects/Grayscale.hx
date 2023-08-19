package dreamengine.plugins.post_processing.effects;

import kha.graphics4.FragmentShader;

class Grayscale extends PostProcessEffect{
    override function createPasses():Array<PostProcessEffectPass> {
        return [new SimplePostProcessPass(kha.Shaders.grayscale_frag)];
    }
}