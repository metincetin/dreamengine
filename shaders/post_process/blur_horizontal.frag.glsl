#version 450

uniform sampler2D tex;

in vec2 texCoord;
in vec4 color;
float weight[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);



out vec4 FragColor;

void main(){ 
    vec2 tex_offset = 1.0 / textureSize(tex, 0); // gets size of single texel
    vec3 result = texture(tex, texCoord).rgb * weight[0]; // current fragment's contribution
        for(int i = 1; i < 5; ++i)
        {
            result += texture(tex, texCoord + vec2(tex_offset.x * i, 0.0)).rgb * weight[i];
            result += texture(tex, texCoord - vec2(tex_offset.x * i, 0.0)).rgb * weight[i];
        }

    FragColor = vec4(result, 1);
}