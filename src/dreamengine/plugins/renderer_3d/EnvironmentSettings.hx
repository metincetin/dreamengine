package dreamengine.plugins.renderer_3d;

import kha.Color;

enum AmbientLightType {
    Color;
    Sky;
}

enum SkyboxType{
    None;
    Material;
}

class EnvironmentSettings{
    public static var active:EnvironmentSettings = new EnvironmentSettings();

    public function new(){}
    
    public var ambientLightType: AmbientLightType = Sky;
    public var ambientLightColor: Color = 0x4F4747;

    public var skybox: SkyboxType = Material;

    public var ambientLightIntensity = 1.0;
}