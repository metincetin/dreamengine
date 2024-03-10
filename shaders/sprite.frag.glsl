#version 450

in vec2 texCoord;
in vec4 color;

uniform sampler2D u_texture;

out vec4 FragColor;

void main() {
    vec4 col = texture(u_texture, texCoord);

    FragColor = col;
}