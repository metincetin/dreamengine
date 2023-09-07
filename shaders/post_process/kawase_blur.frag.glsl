#version 450

uniform sampler2D tex;

uniform float offset;
in vec2 texCoord;
in vec4 color;
float weight[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);



out vec4 FragColor;

void main(){ 
    vec2 tex_offset = 1.0 / textureSize(tex, 0); // gets size of single texel
    vec3 result = texture(tex, texCoord).rgb; 

    result += texture(tex, texCoord + tex_offset * vec2(offset,offset)).rgb;
    result += texture(tex, texCoord + tex_offset * vec2(offset,-offset)).rgb;
    result += texture(tex, texCoord + tex_offset * vec2(-offset,offset)).rgb;
    result += texture(tex, texCoord + tex_offset * vec2(-offset,-offset)).rgb;

    result /= 5;

    FragColor = vec4(result, 1);
}