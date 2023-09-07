#version 450

uniform sampler2D tex;
uniform sampler2D base;
float exposure = 1;

in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    const float gamma = 2.2;
    vec3 hdrColor = texture(base, texCoord).rgb;      
    vec3 bloomColor = texture(tex, texCoord).rgb;
    hdrColor += bloomColor; 
    FragColor = vec4(hdrColor + bloomColor, 1);
}