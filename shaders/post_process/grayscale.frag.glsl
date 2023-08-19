#version 450

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    vec4 fCol = texture(tex, texCoord) * color;
    float gs = 0.299 * fCol.r + 0.587 * fCol.g + 0.114 * fCol.b;
    fCol = vec4(gs);
    FragColor = fCol;

}