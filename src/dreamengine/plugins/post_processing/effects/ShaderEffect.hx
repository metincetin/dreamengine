package dreamengine.plugins.post_processing.effects;

import kha.graphics4.FragmentShader;


class ShaderEffect extends PostProcessEffect
{
    public function new(shader:FragmentShader){
        super();
        passes = [new SimplePostProcessPass(shader)];
    }
}