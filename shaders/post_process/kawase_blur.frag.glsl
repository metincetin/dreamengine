#version 450

uniform sampler2D tex;

uniform float offset;
in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){ 
    vec2 res = 1.0 / textureSize(tex, 0); 

    vec3 result = texture(tex, texCoord).rgb; 

    result += texture(tex, texCoord + vec2(offset,offset) * res).rgb;
    result += texture(tex, texCoord + vec2(offset,-offset) * res).rgb;
    result += texture(tex, texCoord + vec2(-offset,offset) * res).rgb;
    result += texture(tex, texCoord + vec2(-offset,-offset) * res).rgb;

    result /= 5;

    FragColor = vec4(result, 1);
}