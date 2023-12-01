package dreamengine.plugins.renderer_3d;

import kha.Color;

enum AmbientLightType {
    Color;
    Sky;
}

class EnvironmentSettings{
    public static var active:EnvironmentSettings = new EnvironmentSettings();

    public function new(){}
    
    public var ambientLightType: AmbientLightType = Sky;
    public var ambientLightColor: Color;

    public var ambientLightIntensity = 1.0;
}