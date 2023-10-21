
#version 450

uniform sampler2D tex;
uniform sampler2D tex2;

in vec2 texCoord;
in vec4 color;

out vec4 FragColor;





void main(){ 
    FragColor = mix(texture(tex, texCoord), texture(tex2, texCoord), 0.8);
}