package dreamengine.plugins.renderer_3d.materials;

import dreamengine.plugins.renderer_base.DefaultTextures;
import kha.math.FastVector4;
import dreamengine.core.math.Vector3;
import kha.Color;
import kha.Shaders;
import kha.graphics4.FragmentShader;
import dreamengine.plugins.renderer_base.Material;

class PhysicalMaterial extends Material{
    public function new(baseColor:Color = White, roughness:Float = 0.5, emissiveColor:Color = Black, emissionIntensity:Float = 0){
        super(Shaders.simple_vert, Shaders.pbr_frag);
        //addGlobalUniform("_ShadowMap");
        addGlobalUniform("_DepthBias");
        addGlobalUniform("_CameraPosition");
        addGlobalUniform("_DirectionalLightColor");
        addGlobalUniform("_DirectionalLightDirection");
        addGlobalUniform("_LightSpaceMatrix");
        addGlobalUniform("_EnvironmentMap");

        setColorUniform("_BaseColor", new FastVector4(baseColor.R, baseColor.G, baseColor.B, baseColor.A));
        setColorUniform("_Emission", new FastVector4(0,0,0,0));
        setFloatUniform("_Roughness", roughness);
        setColorUniform("_Emission", new FastVector4(emissiveColor.R, emissiveColor.G, emissiveColor.B, emissionIntensity));

        setTextureUniform("_BaseMap", DefaultTextures.getWhite());
        setTextureUniform("_AmbientOcclusionMap", DefaultTextures.getWhite());
        setTextureUniform("_NormalMap", DefaultTextures.getNormal());
    }
}