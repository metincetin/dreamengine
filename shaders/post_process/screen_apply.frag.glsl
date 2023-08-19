#version 450

uniform sampler2D tex;
uniform sampler2D base;
float exposure = 1;

in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    const float gamma = 2.2;
    vec3 hdrColor = texture(base, texCoord).rgb;      
    vec3 bloomColor = texture(tex, texCoord).rgb;
    hdrColor += bloomColor; // additive blending
    // tone mapping
    vec3 result = vec3(1.0) - exp(-hdrColor * exposure);
    // also gamma correct while we're at it       
    result = pow(result, vec3(1.0 / gamma));
    FragColor = vec4(result, 1.0);
}