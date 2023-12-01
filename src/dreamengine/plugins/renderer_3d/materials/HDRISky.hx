
package dreamengine.plugins.renderer_3d.materials;

import dreamengine.plugins.dreamui.elements.Image;
import kha.math.FastVector4;
import dreamengine.core.math.Vector3;
import kha.Color;
import kha.Shaders;
import kha.graphics4.FragmentShader;
import dreamengine.plugins.renderer_base.Material;

class HDRISky extends Material{
    public function new(exposure:Float = 1.0){
        super(Shaders.simple_vert, Shaders.hdri_sky_frag);
    }

    public function setTexture(texture:Image){

    }
}