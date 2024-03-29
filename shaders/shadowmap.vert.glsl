#version 450

// Input vertex data, different for all executions of this shader
in vec3 vertexPosition;
in vec3 vertexColor;
in vec3 vertexNormal;


// Values that stay constant for the whole mesh
uniform mat4 Model;
uniform mat4 _LightSpaceMatrix;

void main() {
	gl_Position = _LightSpaceMatrix * Model * vec4(vertexPosition, 1.0);
}