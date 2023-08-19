#version 450

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    vec4 col = vec4(0);
    for(int i= 0;i<12;i++){
        col += texture(tex, texCoord + vec2(i * 0.001, 0)) * color;
    }
    col /= 12;
    FragColor = col;
}