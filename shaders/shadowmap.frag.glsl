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

uniform vec3 cameraPosition;


void main() {
	// Output color = color specified in the vertex shader,
	// interpolated between all 3 surrounding vertices
}