package dreamengine.plugins.post_processing.passes;

import kha.math.FastVector4;
import kha.math.FastMatrix4;
import dreamengine.core.math.Vector2;
import haxe.zip.Writer;
import kha.math.Vector3;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import dreamengine.device.Screen;
import kha.Image;
import kha.math.FastVector2;
import kha.graphics4.*;
import dreamengine.plugins.renderer_base.components.Camera;

class RadialBlur extends SimplePostProcessPass{
	var samplesLocation:ConstantLocation;
	var originLocation:ConstantLocation;
	var powerLocation:ConstantLocation;

    var renderTarget:Image;
    var samples = 16;
    var falloff = false;
	var falloffLocation:ConstantLocation;


    public function new(samples = 16, falloff:Bool, downsample:Int = 1){
        super(kha.Shaders.radial_blur_frag);

        var res = Screen.getResolution();

        this.samples = samples;
        this.falloff = falloff;

        if (downsample <= 1)
            return;

        renderTarget = Image.createRenderTarget(Std.int(res.x / downsample), Std.int(res.y / downsample));
    }

    override function createPipeline() {
        super.createPipeline();
        samplesLocation = pipeline.getConstantLocation("u_samples");
        originLocation = pipeline.getConstantLocation("u_origin");
        powerLocation = pipeline.getConstantLocation("u_power");
        falloffLocation = pipeline.getConstantLocation("u_falloff");
    }

    override function passValues(graphics:Graphics, camera:Camera) {
        graphics.setInt(samplesLocation, samples);
        graphics.setFloat(powerLocation, 1);
        graphics.setBool(falloffLocation, falloff);

        var width = renderTarget != null ? renderTarget.width : camera.renderTexture.width;
        var height = renderTarget != null ? renderTarget.height : camera.renderTexture.height;

        var sunDir = ShaderGlobals.getFloat3("_DirectionalLightDirection");
        if (sunDir != null){
            var sunPos = sunDir * camera.clippingPlanes.y;
            var v = new FastVector4(sunPos.x, sunPos.y, sunPos.z, 1);
            var clip = camera.getViewProjectionMatrix().multvec(v);
            var ndc = new Vector2(
                clip.x / clip.w,
                clip.y / clip.w,
            );

            var screenSpace = new Vector2(
                (1 + ndc.x) * 0.5,
                1 - (1 - ndc.y) * 0.5,
            );
            graphics.setVector2(originLocation, new FastVector2(screenSpace.x, screenSpace.y));
        }
    }

    override function getCustomRenderTarget():Image {
        return renderTarget;
    }
}