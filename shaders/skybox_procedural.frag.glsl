#version 450


in vec3 normal;
in vec4 color;
in mat4 view;
in vec3 Position_World;

uniform mat4 MVP;
uniform mat4 Model;
uniform mat4 V;
uniform vec3 cameraPosition;


out vec4 FragColor;

#include "include/lighting.inc.glsl"

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

void main(){
	vec3 Sun = -GetMainLightDirection();
	vec3 n = normalize(normal);
	
	vec3 view = normalize(cameraPosition - Position_World);
	
	float c = sdCircle(n.yz, 100);

	float v = dot(n, Sun);
	
	float angle = acos(v);

	float sundisk = 1 - smoothstep(0.04, 0.06, angle);

	vec3 skyColor = vec3(0.4,0.5,0.5);


	vec3 finalColor = mix(skyColor, sundisk * GetMainLightColor(), sundisk);

	
	FragColor.rgb = finalColor;
}