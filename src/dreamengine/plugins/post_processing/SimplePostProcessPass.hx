package dreamengine.plugins.post_processing;

import kha.graphics4.FragmentShader;

class SimplePostProcessPass extends PostProcessEffectPass{
    var shader:FragmentShader = kha.Shaders.painter_image_frag;

    public function new(shader:FragmentShader = null){
        if (shader != null){
            this.shader = shader;
        }
        super();
    }
    override function getShader():FragmentShader {
        return shader;
    }
}