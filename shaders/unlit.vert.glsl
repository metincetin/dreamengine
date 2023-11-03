#version 450

// Input vertex data, different for all executions of this shader
in vec3 vertexPosition;
in vec4 vertexColor;
in vec3 vertexNormal;

out vec4 color;

// Values that stay constant for the whole mesh
uniform mat4 MVP;
uniform mat4 M;
uniform mat4 V;



void main() {
	// Output position of the vertex, in clip space: MVP * position
	gl_Position = MVP * vec4(vertexPosition, 1.0);
	
	color = vertexColor;
}