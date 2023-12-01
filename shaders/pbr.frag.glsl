#version 450
#include "include/lighting.inc.glsl"

in vec3 fragmentColor;

in vec3 normal;
in vec3 Position_World;
in vec4 color;
in vec4 FragPosLightSpace;
in mat4 view;



out vec4 fragColor;

uniform vec4 baseColor = vec4(1);
uniform vec4 emission;
uniform float roughness;


uniform sampler2D shadowMap;
uniform float depthBias = 0.3;

uniform vec3 cameraPosition;

float specularStrength = 1.0;

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
    float depth = texture(shadowMap, projCoords.xy).r; 
    // check whether current frag pos is in shadow

    float shadow = 0.0;
    vec2 texelSize = 1.0 / textureSize(shadowMap, 0);


    float bias = mix(0.05, 0, dot(normalize(normal), -directionalLightDirection));
    //float bias = max(0.05 * (1.0 - dot(normal, directionalLightDirection)), 0.0005);  


    // for(int x = -1; x <= 1; ++x)
    // {
    //     for(int y = -1; y <= 1; ++y)
    //     {
    //         float pcfDepth = texture(shadowMap, projCoords.xy + vec2(x, y) * texelSize).r; 

    //         shadow += currentDepth + bias > pcfDepth ? 1.0 : 0.0;        
    //     }    
    // }
    // shadow /= 9.0;
    if (projCoords.z - bias> depth) return 1;

    return 0;
}  

void main() {
	// Output color = color specified in the vertex shader,
	// interpolated between all 3 surrounding vertices
	vec3 normalizedNormal = normalize(normal);
	float ldn = max(0.0, dot(-GetMainLightDirection(), normalizedNormal));

	vec3 viewDir = normalize(cameraPosition - Position_World);

    vec3 H = normalize(-GetMainLightDirection()+ viewDir);
    float ndh = max(0, dot(normalizedNormal, H));

	float spec = pow(ndh, 64);
	vec3 specular = specularStrength * spec * directionalLightColor * ldn;  
    float shadow = 1 - ShadowCalculation(FragPosLightSpace);

    vec3 diffuse = baseColor.rgb * ldn * shadow;
    vec3 ambient = GetMainLightColor() * .1;

    vec3 fn = ((ambient + diffuse) * baseColor.rgb + (specular * ldn * shadow)); 


	fragColor = vec4((emission.rgb * emission.a) + PBR(baseColor.rgb, GetMainLightColor().rgb, normalizedNormal, -GetMainLightDirection(), viewDir, roughness, _AmbientColor.rgb), 1);
}