package dreamengine.plugins.post_processing.effects;

import kha.graphics4.FragmentShader;

class Invert extends SinglePassPostProcessEffect{

    override function getShader():FragmentShader {
        return kha.Shaders.invert_frag;
    }
}