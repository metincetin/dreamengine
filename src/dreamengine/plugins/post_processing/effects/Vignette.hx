package dreamengine.plugins.post_processing.effects;

import kha.Shaders;
import kha.Image;
import kha.math.FastVector4;
import kha.math.FastVector3;
import kha.graphics4.PipelineState;
import kha.Framebuffer;
import kha.graphics4.VertexStructure;
import kha.Color;
import kha.graphics4.FragmentShader;

class Vignette extends PostProcessEffect{

    public var color:Color = Black;
    public var power:Float = 0.15;
    public var intensity:Float = 25;

    override function createPasses():Array<PostProcessEffectPass> {
        return [new SimplePostProcessPass(Shaders.vignette_frag)];
    }

    override function sendValues(img:Image) {
        img.g4.setVector4(img.g2.pipeline.getConstantLocation("vignetteColor"), new FastVector4(color.R, color.G, color.B, color.A));
        img.g4.setFloat(img.g2.pipeline.getConstantLocation("power"), power);
        img.g4.setFloat(img.g2.pipeline.getConstantLocation("intensity"), intensity);
    }
}