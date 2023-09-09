#version 450

// Input vertex data, different for all executions of this shader
in vec3 vertexPosition;
in vec3 vertexColor;
in vec3 vertexNormal;

out vec3 normal;
out vec3 worldPos;
out vec3 color;
out vec4 FragPosLightSpace;
out mat4 view;

// Values that stay constant for the whole mesh
uniform mat4 MVP;
uniform mat4 M;
uniform mat4 V;
uniform mat4 lightSpaceMatrix;


vec4 objectToWorld(vec3 obj){
	return M * vec4(obj, 1.0);
}

void main() {
	gl_Position = lightSpaceMatrix * M * vec4(vertexPosition, 1.0);
	
	color = vertexColor;


	// The color of each vertex will be interpolated
	// to produce the color of each fragment

	worldPos = (M * vec4(vertexPosition, 1.0)).xyz;
    FragPosLightSpace = lightSpaceMatrix * vec4(worldPos, 1.0);
}