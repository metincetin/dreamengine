#version 450

uniform sampler2D tex;

uniform vec2 u_origin;
uniform int u_samples = 4;
uniform bool u_falloff;


in vec2 texCoord;


out vec4 FragColor;

void main(){
    vec2 texSize = textureSize(tex, 0);
    float aspect = texSize.x / texSize.y;


    vec2 dir =  (texCoord - (u_origin));
    float length = length(dir);


    if (length > 1) 
    {
        FragColor = vec4(0,0,0,1);
        return;
    }


    vec4 col = vec4(0);
    for(int i = 0; i < u_samples; i++){
        float power = 1 - (i / float(u_samples)) * length;
        col += texture(tex, dir * power + u_origin);
    }

    col /= u_samples;

    if (u_falloff){
        float falloff = smoothstep(1, 0.8, length);

        col *= falloff;
    }

    FragColor = col;
    FragColor.a = 1;
}