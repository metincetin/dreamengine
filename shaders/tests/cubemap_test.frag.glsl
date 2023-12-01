#version 450
// Interpolated values from the vertex shaders
in vec3 fragmentColor;

in vec3 normal;
in vec3 Position_World;
in vec4 color;
in vec4 FragPosLightSpace;
in mat4 view;


out vec4 fragColor;

uniform samplerCube environmentMap;

void main() {
	// Output color = color specified in the vertex shader,
	// interpolated between all 3 surrounding vertices
	vec3 normalizedNormal = normalize(normal);

	fragColor = vec4(texture(environmentMap, normalizedNormal).rgb, 1);
}