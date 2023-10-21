package dreamengine.core;

import kha.math.FastMatrix4;
import dreamengine.plugins.renderer_base.Mesh;
import dreamengine.plugins.renderer_base.Material;

class Renderable{
    public var mesh:Mesh;
    public var material:Material;
    public var modelMatrix: FastMatrix4;
    public function new(){}
}