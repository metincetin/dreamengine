#version 450

uniform sampler2D tex;
uniform vec4 vignette_color = vec4(0);
uniform float multiplier = 1;

in vec2 texCoord;
in vec4 color;




out vec4 FragColor;

void main(){
    vec4 fCol = texture(tex, texCoord);

    float vignette = distance(vec2(0.5), texCoord) * multiplier;
    vignette = clamp(vignette, 0, 1);


    FragColor = mix(fCol,vignette_color, vignette * vignette_color.a);
    FragColor = mix(vec4(1,0,0,1), vec4(0,1,0,1), vignette * vignette_color.a);
}