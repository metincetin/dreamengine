#version 450
// Interpolated values from the vertex shaders
in vec3 fragmentColor;

in vec3 normal;
in vec3 worldPos;

out vec4 fragColor;

uniform vec3 directionalLightColor;
uniform vec3 directionalLightDirection;

uniform vec3 additionalLight0_color;
uniform float additionalLight0_attenuation;
uniform vec3 additionalLight0_position;


void main() {
	// Output color = color specified in the vertex shader,
	// interpolated between all 3 surrounding vertices
	float ldn = max(0.0, dot(-directionalLightDirection, normal));



	fragColor = vec4(vec3(ldn), 1.0);
}