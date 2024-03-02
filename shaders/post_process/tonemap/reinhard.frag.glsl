#version 450

uniform sampler2D tex;
in vec2 texCoord;


out vec4 FragColor;
// https://www.shadertoy.com/view/lslGzl

void main(){
    const float gamma = 2.2;
    vec3 color = texture(tex, texCoord).rgb;

    float luma = dot(color, vec3(0.2126, 0.7152, 0.0722));
	float toneMappedLuma = luma / (1. + luma);
	color *= toneMappedLuma / luma;

    FragColor = vec4(color, 1);
}