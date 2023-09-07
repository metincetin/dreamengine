#version 450

uniform sampler2D tex;
uniform vec4 vignetteColor = vec4(0);
uniform float power = 1.5;
uniform float intensity = 1;

in vec2 texCoord;
in vec4 color;




out vec4 FragColor;

void main(){
    vec4 fCol = texture(tex, texCoord);

    vec2 u = texCoord * (1. - texCoord.yx);

    float vignette = 1 - pow(u.x * u.y * intensity, power);
    vignette = clamp(vignette, 0, 1);


    FragColor = mix(fCol,vignetteColor, vignette);
}