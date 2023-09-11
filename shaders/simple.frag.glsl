#version 450
// Interpolated values from the vertex shaders
in vec3 fragmentColor;

in vec3 normal;
in vec3 worldPos;
in vec3 color;
in vec4 FragPosLightSpace;
in mat4 view;


out vec4 fragColor;

uniform vec4 baseColor;

uniform vec3 directionalLightColor;
uniform vec3 directionalLightDirection;

uniform vec3 additionalLight0_color;
uniform float additionalLight0_attenuation;
uniform vec3 additionalLight0_position;

uniform sampler2D shadowMap;
uniform float depthBias = 0.1;

uniform vec3 cameraPosition;

float specularStrength = 1.0;

float ShadowCalculation(vec4 fragPosLightSpace)
{
    // perform perspective divide
    vec3 projCoords = fragPosLightSpace.xyz / fragPosLightSpace.w;
    // transform to [0,1] range
    projCoords = projCoords * 0.5 + 0.5;
    // get closest depth value from light's perspective (using [0,1] range fragPosLight as coords)
    float closestDepth = texture(shadowMap, projCoords.xy).r; 
    // get depth of current fragment from light's perspective
    float currentDepth = projCoords.z;
    // check whether current frag pos is in shadow
    //float shadow = currentDepth - depthBias > closestDepth  ? 1.0 : 0.0;
      if(projCoords.z > 1.0)
        return 0.0;
    float shadow = 0.0;
    vec2 texelSize = 1.0 / textureSize(shadowMap, 0);
    for(int x = -1; x <= 1; ++x)
    {
        for(int y = -1; y <= 1; ++y)
        {
            float pcfDepth = texture(shadowMap, projCoords.xy + vec2(x, y) * texelSize).r; 
            float bias = max(0.05 * (1.0 - dot(normal, directionalLightDirection)), 0.005) + depthBias;
            shadow += currentDepth - bias > pcfDepth ? 1.0 : 0.0;        
        }    
    }
    shadow /= 9.0;

    return shadow;
}  

void main() {
	// Output color = color specified in the vertex shader,
	// interpolated between all 3 surrounding vertices
	vec3 normalizedNormal = normalize(normal);
	float ldn = max(0.0, dot(directionalLightDirection, normalizedNormal));

	vec3 viewDir = normalize(worldPos - cameraPosition);

	vec3 reflectDir = reflect(directionalLightDirection, normalizedNormal);  
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 64);
	vec3 specular = specularStrength * spec * directionalLightColor * ldn;  
    float shadow = 1 - ShadowCalculation(FragPosLightSpace);
    //shadow = 1;

    vec3 diffuse = baseColor.rgb * ldn * shadow;
    vec3 ambient = directionalLightColor * .1;

    vec3 fn = ((ambient + diffuse) * baseColor.rgb + (specular * ldn * shadow)); 


	fragColor = vec4(fn, 1);
}