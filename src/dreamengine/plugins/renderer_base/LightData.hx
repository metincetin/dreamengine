package dreamengine.plugins.renderer_base;

import kha.math.FastMatrix4;
import kha.Color;
import dreamengine.core.math.Vector3;

enum LightType{
    Directional;
    Point;
    Spot;
}

typedef LightData = {
    type:LightType,
    position:Vector3,
    direction:Vector3,
    range:Float,
    color:Color,
    intensity:Float,
    projection:FastMatrix4
}