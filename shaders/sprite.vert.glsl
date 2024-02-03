#version 450

in vec3 vertexPosition;
in vec4 vertexColor;
in vec2 uv;
//in vec3 vertexNormal;

out vec4 color;
out vec2 texCoord;

uniform mat4 MVP;
uniform mat4 _LightSpaceMatrix;

void main() {
	gl_Position = MVP * vec4(vertexPosition, 1.0);
	texCoord = uv.xy;

    color = vertexColor;
}