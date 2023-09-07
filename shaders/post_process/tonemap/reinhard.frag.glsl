#version 450

uniform sampler2D tex;
in vec2 texCoord;

float exposure = 1;

out vec4 FragColor;

void main(){
    const float gamma = 2.2;
    vec3 hdrColor = texture(tex, texCoord).rgb;
  
    // reinhard tone mapping
    hdrColor = hdrColor / (hdrColor + vec3(1.0));

    vec3 mapped = vec3(1.0) - exp(-hdrColor * exposure);
    // gamma correction 
    mapped = pow(mapped, vec3(1.0 / gamma));
  
    FragColor = vec4(mapped, 1.0);
}