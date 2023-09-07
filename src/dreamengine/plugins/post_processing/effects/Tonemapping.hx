package dreamengine.plugins.post_processing.effects;


class Tonemapping extends PostProcessEffect{
    override function createPasses():Array<PostProcessEffectPass> {
        return [new SimplePostProcessPass(kha.Shaders.reinhard_frag)];
    }
}