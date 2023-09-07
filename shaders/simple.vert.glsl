#version 450

// Input vertex data, different for all executions of this shader
in vec3 vertexPosition;
in vec3 vertexColor;
in vec3 vertexNormal;

out vec3 normal;
out vec3 worldPos;
out vec3 color;

// Values that stay constant for the whole mesh
uniform mat4 MVP;
uniform mat4 M;
uniform mat4 V;

vec4 objectToWorld(vec3 obj){
	return M * vec4(obj, 1.0);
}

void main() {
	// Output position of the vertex, in clip space: MVP * position
	gl_Position = MVP * vec4(vertexPosition, 1.0);
	
	color = vertexColor;

	// The color of each vertex will be interpolated
	// to produce the color of each fragment

	worldPos = (M * vec4(vertexPosition, 1.0)).xyz;

	normal = (M * vec4(vertexNormal, 0.0)).xyz;
}