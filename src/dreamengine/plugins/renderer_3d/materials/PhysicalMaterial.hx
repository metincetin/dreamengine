package dreamengine.plugins.renderer_3d.materials;

import dreamengine.plugins.renderer_base.DefaultTextures;
import kha.math.FastVector4;
import dreamengine.core.math.Vector3;
import kha.Color;
import kha.Shaders;
import kha.graphics4.FragmentShader;
import dreamengine.plugins.renderer_base.Material;

class PhysicalMaterial extends Material{
    public function new(baseColor:Color = White, roughness:Float = 0.5){
        super(Shaders.simple_vert, Shaders.pbr_frag);
        //addGlobalUniform("_ShadowMap");
        addGlobalUniform("_DepthBias");
        addGlobalUniform("_CameraPosition");
        addGlobalUniform("_DirectionalLightColor");
        addGlobalUniform("_DirectionalLightDirection");
        addGlobalUniform("_LightSpaceMatrix");

        setColorParam("_BaseColor", new FastVector4(baseColor.R, baseColor.G, baseColor.B, baseColor.A));
        setFloatParam("_Roughness", roughness);
        setTextureParam("_BaseMap", DefaultTextures.getWhite());
        setTextureParam("_AmbientOcclusionMap", DefaultTextures.getWhite());
        setTextureParam("_NormalMap", DefaultTextures.getNormal());

        setTextureParam("_BaseMap", kha.Assets.images.get("stone_brick_wall_001_diff_2k"));
        setTextureParam("_AmbientOcclusionMap", kha.Assets.images.get("stone_brick_wall_001_ao_2k"));

        setTextureParam("_NormalMap", kha.Assets.images.stone_brick_wall_001_nor_gl_2k);
    }
}