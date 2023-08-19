#version 450

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    vec4 col = texture(tex, texCoord) * color;
    float intensity = dot(col.rgb, vec3(0.2126, 0.7152, 0.0722));
    intensity = step(0.95, intensity);

    FragColor = col * intensity;

}