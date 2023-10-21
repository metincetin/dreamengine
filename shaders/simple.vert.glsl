#version 450

// Input vertex data, different for all executions of this shader
in vec3 vertexPosition;
in vec3 uv;
in vec3 vertexNormal;

out vec3 normal;
out vec3 Position_World;
out vec3 color;
out vec4 FragPosLightSpace;
out mat4 view;

// Values that stay constant for the whole mesh
uniform mat4 MVP;
uniform mat4 Model;
uniform mat4 V;
uniform mat4 lightSpaceMatrix;

void main() {
	// Output position of the vertex, in clip space: MVP * position
	gl_Position = MVP * vec4(vertexPosition, 1.0);
	
	//color = vertexColor;


	// The color of each vertex will be interpolated
	// to produce the color of each fragment

	Position_World = (Model * vec4(vertexPosition, 1.0)).xyz;
    FragPosLightSpace = lightSpaceMatrix * vec4(Position_World, 1.0);

	view = V;


	normal = (Model * vec4(vertexNormal, 0.0)).xyz;
}