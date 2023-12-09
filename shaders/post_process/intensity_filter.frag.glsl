#version 450

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    vec4 col = texture(tex, texCoord);
    float brightness = max(max(col.x, col.y), col.z);

    float intensity = max(brightness - 3.1, 0);

    FragColor = vec4(vec3(intensity), 1);
}