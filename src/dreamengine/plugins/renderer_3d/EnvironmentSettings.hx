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

typedef DistanceFog = {
    enabled:Bool,
    density:Float,
    color:Color
};

typedef HeightFog = {
    enabled:Bool,
    start:Float,
    end:Float,
    color:Color,
    opacity:Float
};

class EnvironmentSettings{
    public static var active:EnvironmentSettings = new EnvironmentSettings();


    public function new(){}
    
    public var ambientLightType: AmbientLightType = Sky;
    public var ambientLightColor: Color = 0x4F4747;

    public var skybox: SkyboxType = Material;

    public var ambientLightIntensity = 1.0;

    public var distanceFog:DistanceFog = {
        enabled: false,
        density: 0.5,
        color: 0x5A5A5A
    };

    public var heightFog:HeightFog = {
        enabled: false,
        start: 0,
        end: 5,
        color: 0x5A5A5A,
        opacity: 1
    };
}