#version 450

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;

out vec4 FragColor;



void main(){ 
    vec2 texel = 1 / textureSize(tex, 0);
    vec4 col;
    col += texture(tex, texCoord + vec2(1,1) * texel) * 0.125;
    col += texture(tex, texCoord + vec2(-1,1) * texel) * 0.125;
    col += texture(tex, texCoord + vec2(1,-1) * texel) * 0.125;
    col += texture(tex, texCoord + vec2(-1,-1) * texel) * 0.125;


    float v = 0.125 / 4;
    col += texture(tex, texCoord) * v;
    col += texture(tex, texCoord + vec2(-1,0) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(-1,-1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,-1) * texel * 2) * v;

    col += texture(tex, texCoord) * v;
    col += texture(tex, texCoord + vec2(0,1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(1,1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,1) * texel * 2) * v;

    col += texture(tex, texCoord) * v;
    col += texture(tex, texCoord + vec2(0,-1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(1,-1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,1) * texel * 2) * v;

    col += texture(tex, texCoord) * v;
    col += texture(tex, texCoord + vec2(-1, 0) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(-1,-1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,-1) * texel * 2) * v;

    FragColor = col;
}