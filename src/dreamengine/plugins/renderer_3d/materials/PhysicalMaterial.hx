package dreamengine.plugins.renderer_3d.materials;

import kha.math.FastVector4;
import dreamengine.core.math.Vector3;
import kha.Color;
import kha.Shaders;
import kha.graphics4.FragmentShader;
import dreamengine.plugins.renderer_base.Material;

class PhysicalMaterial extends Material{
    public function new(baseColor:Color = White, roughness:Float = 0.5){
        super(Shaders.simple_vert, Shaders.pbr_frag);
        addGlobalUniform("shadowMap");
        addGlobalUniform("depthBias");
        addGlobalUniform("cameraPosition");
        addGlobalUniform("directionalLightColor");
        addGlobalUniform("directionalLightDirection");

        setColorParam("baseColor", new FastVector4(baseColor.R, baseColor.G, baseColor.B, baseColor.A));
        setFloatParam("roughness", roughness);
    }
}