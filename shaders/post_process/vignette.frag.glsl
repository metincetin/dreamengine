#version 450

uniform sampler2D tex;
uniform vec4 vignetteColor = vec4(0.0627, 0.0627, 0.0627, 0.0);
uniform float power = 1.5;
uniform float intensity = 1;

in vec2 texCoord;
in vec4 color;




out vec4 FragColor;

void main(){
    vec4 fCol = texture(tex, texCoord);

    float vignette = length(texCoord - vec2(0.5));
    vignette = pow(vignette, power);
    vignette = clamp(vignette, 0.0,1.0);


    FragColor = mix(fCol, vignetteColor, vignette * intensity);
}