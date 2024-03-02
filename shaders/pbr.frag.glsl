#version 450
#include "include/lighting.inc.glsl"
#include "include/common.inc.glsl"

in vec3 fragmentColor;

in vec3 normal;
in vec3 Position_World;
in vec4 color;
in vec2 texCoord;
in vec4 FragPosLightSpace;
in mat4 view;
in mat3 TBN;



out vec4 fragColor;

uniform vec4 _BaseColor = vec4(1);
uniform sampler2D _BaseMap;
uniform sampler2D _NormalMap;
uniform sampler2D _AmbientOcclusionMap;
uniform vec4 _Emission;
uniform float _Roughness;


uniform bool _DistanceFog;
uniform vec4 _DistanceFogColor;
uniform float _DistanceFogDensity;

uniform bool _HeightFog;
uniform vec4 _HeightFogColor;
uniform float _HeightFogStart;
uniform float _HeightFogEnd;

uniform sampler2D _ShadowMap;
uniform float _DepthBias = 0.3;
uniform vec3 _CameraPosition;

float ShadowCalculation(vec4 fragPosLightSpace)
{
    // perform perspective divide
    vec3 projCoords = fragPosLightSpace.xyz / fragPosLightSpace.w;
    // transform to [0,1] range
    projCoords = projCoords * 0.5 + 0.5;
    if(projCoords.z > 1.0){
        return 0;
    }
    // get closest depth value from light's perspective (using [0,1] range fragPosLight as coords)
    float depth = texture(_ShadowMap, projCoords.xy).r; 
    // check whether current frag pos is in shadow

    float shadow = 0.0;
    vec2 texelSize = 1.0 / textureSize(_ShadowMap, 0);


    //float bias = mix(0.05, 0, dot(normalize(normal), -GetMainLightDirection()));
    //float bias = max(0.05 * (1.0 - dot(normalize(normal), -GetMainLightDirection())), 0.0005);  

    if (projCoords.z - _DepthBias > depth) return 1;

    return 0;
}  

vec3 CalculateNormal(){
    vec3 textureNormal = texture(_NormalMap, texCoord).xyz;
    textureNormal = textureNormal * 2 - 1;
//normalize(TBN * textureNormal);
    return normalize(normal);
}

void main() {
    vec3 finalNormal = CalculateNormal();
	float ldn = max(0.0, dot(-GetMainLightDirection(), finalNormal));

	vec3 viewDir = normalize(_CameraPosition - Position_World);

    vec3 H = normalize(-GetMainLightDirection()+ viewDir);
    float ndh = max(0, dot(finalNormal, H));

    float shadow = 1;//1 - ShadowCalculation(FragPosLightSpace);

    
    vec4 difColor = texture(_BaseMap, texCoord) * _BaseColor;

    float ao = texture(_AmbientOcclusionMap, texCoord).r;
    vec3 ambient = _AmbientColor.rgb * difColor.rgb * ao;

    vec3 diffuse = PBR(difColor.rgb, GetMainLightColor().rgb, finalNormal, -GetMainLightDirection(), viewDir, _Roughness) * shadow;

    vec3 emissive = _Emission.rgb * _Emission.a;

    vec3 finalColor = diffuse + ambient + emissive;

    if (_DistanceFog){
        finalColor = applyDistanceFog(finalColor, _DistanceFogColor.xyz, _DistanceFogDensity, gl_FragCoord.z / gl_FragCoord.w);
    }

    if (_HeightFog){
        finalColor = applyHeightFog(finalColor, _HeightFogColor, _HeightFogStart, _HeightFogEnd, Position_World.y);
    }

    fragColor = vec4(finalColor, 1);
}