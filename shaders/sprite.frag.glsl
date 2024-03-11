#version 450

in vec2 texCoord;
in vec4 color;

uniform sampler2D u_texture;
uniform vec4 u_region = vec4(0,0,1,1);

out vec4 FragColor;


void main() {
    vec4 col = texture(u_texture, texCoord * u_region.zw + u_region.xy);

    FragColor = col;
}