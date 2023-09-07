#version 450

const highp float NOISE_GRANULARITY = 0.8/255.0;

uniform sampler2D tex;
in vec2 texCoord;

out vec4 FragColor;

highp float random(highp vec2 coords) {
   return fract(sin(dot(coords.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void main(){
    vec4 col = texture(tex, texCoord);
    col += mix(-NOISE_GRANULARITY, NOISE_GRANULARITY, random(texCoord));

    FragColor = col;
}