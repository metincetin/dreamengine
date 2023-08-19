#version 450

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    vec4 fCol = texture(tex, texCoord) * color;
    fCol.rgb = 1.0 - fCol.rgb;
    FragColor = fCol;
}