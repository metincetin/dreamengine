#version 450

in vec3 vertexPosition;
in vec3 uv;
in vec3 vertexNormal;

out vec3 normal;
out vec4 color;
out vec2 texCoord;
out vec3 pos;

uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;


void main() {
	vec4 p = ProjectionMatrix * ViewMatrix * vec4(vertexPosition, 1.0);
	
	texCoord = uv.xy;

	normal = vertexNormal;

	gl_Position = p.xyww;

    pos = transpose(mat3(ViewMatrix)) * (inverse(ProjectionMatrix) * gl_Position).xyz;
}