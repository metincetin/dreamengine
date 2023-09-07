#version 450
// Interpolated values from the vertex shaders
in vec3 fragmentColor;

in vec3 normal;
in vec3 worldPos;
in vec3 color;


out vec4 fragColor;

uniform vec4 baseColor;

uniform vec3 directionalLightColor;
uniform vec3 directionalLightDirection;

uniform vec3 additionalLight0_color;
uniform float additionalLight0_attenuation;
uniform vec3 additionalLight0_position;

uniform vec3 cameraPosition;

float specularStrength = 1.0;


void main() {
	// Output color = color specified in the vertex shader,
	// interpolated between all 3 surrounding vertices
	vec3 normalizedNormal = normalize(normal);
	float ldn = max(0.0, dot(directionalLightDirection, normalizedNormal));

	vec3 viewDir = normalize(cameraPosition - worldPos);

	vec3 reflectDir = reflect(directionalLightDirection, normalizedNormal);  
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 64);
	vec3 specular = specularStrength * spec * directionalLightColor * ldn;  

	fragColor = baseColor * ldn + vec4(specular, 1);
}