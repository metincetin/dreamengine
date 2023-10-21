#version 450

#include "include/gaussian_blur.inc.glsl"

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;

out vec4 FragColor;

uniform vec2 direction;




void main(){ 
    vec4 result = blur13(tex, texCoord, textureSize(tex, 0), direction);

    FragColor = result;
}