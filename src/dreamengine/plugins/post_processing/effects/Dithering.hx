package dreamengine.plugins.post_processing.effects;

import kha.graphics4.FragmentShader;

class Dithering extends PostProcessEffect{
    override function createPasses():Array<PostProcessEffectPass> {
        return [new SimplePostProcessPass(kha.Shaders.dithering_frag)];
    }
}