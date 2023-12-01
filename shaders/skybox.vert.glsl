#version 450

in vec3 vertexPosition;
in vec3 uv;
in vec3 vertexNormal;

out vec3 normal;
out vec4 color;
out vec2 texCoord;

uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;


void main() {
	gl_Position = ProjectionMatrix * ViewMatrix * vec4(vertexPosition,  1.0);
	
	texCoord = uv.xy;

	normal = vertexNormal;//(Model * vec4(vertexNormal, 0.0)).xyz;
}