#version 450

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;

out vec4 FragColor;



void main(){ 
    vec2 texel = 1 / textureSize(tex, 0);
    vec4 col = vec4(0);
    float v = 0.5 / 4.0;
    col += texture(tex, texCoord + vec2(1,1) * texel) * v;
    col += texture(tex, texCoord + vec2(-1,1) * texel) * v;
    col += texture(tex, texCoord + vec2(1,-1) * texel) * v;
    col += texture(tex, texCoord + vec2(-1,-1) * texel) * v;

    v = 0.125 / 4.0;
    col += texture(tex, texCoord + vec2(-1,1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,0) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(-1,-1) * texel * 2) * v;

    col += texture(tex, texCoord + vec2(1,1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,0) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(1,-1) * texel * 2) * v;

    col += texture(tex, texCoord + vec2(-1,-1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(-1,0) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,0) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(-1,0) * texel * 2) * v;

    col += texture(tex, texCoord + vec2(1,0) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(1,1) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(0,0) * texel * 2) * v;
    col += texture(tex, texCoord + vec2(-1,0) * texel * 2) * v;

    FragColor = vec4(col.rgb, 1);
}