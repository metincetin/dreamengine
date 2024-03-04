#version 450

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    float treshold = 1.0;

    vec4 col = min(vec4(100), texture(tex, texCoord));

    float brightness = max(max(col.x, col.y), col.z);
    float softness = clamp(brightness - treshold + 0.5, 0.0, 2.0 * 0.5);

    softness = (softness * softness) / (4.0 * 0.5 + 1e-4);
    float multiplier = max(brightness - treshold, softness) / max(brightness, 1e-4);

    FragColor = vec4(col.rgb * multiplier , 1);
}