#version 450

uniform sampler2D tex;
uniform sampler2D sceneTexture;



in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    vec4 main = texture(sceneTexture, texCoord);
    vec4 blend = texture(tex, texCoord);

    FragColor = main + blend;
}