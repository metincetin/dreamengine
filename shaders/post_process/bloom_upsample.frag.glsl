
#version 450

uniform sampler2D tex;
uniform sampler2D tex2;

in vec2 texCoord;
in vec4 color;

out vec4 FragColor;





void main(){ 

    vec2 texel = 1 / textureSize(tex, 0);

    vec3 lowMip = vec3(0);

 

    float radius = 2;

    lowMip = texture(tex, texCoord + texel * radius * vec2(-1, 1)).rgb * 1;
    lowMip = texture(tex, texCoord + texel * radius * vec2(0, 1)).rgb * 2;
    lowMip = texture(tex, texCoord + texel * radius * vec2(1, 1)).rgb * 1;
    lowMip = texture(tex, texCoord + texel * radius * vec2(0, 1)).rgb * 2;
    lowMip = texture(tex, texCoord + texel * radius * vec2(1, -1)).rgb * 1;
    lowMip = texture(tex, texCoord + texel * radius * vec2(0, 1)).rgb * 2;
    lowMip = texture(tex, texCoord + texel * radius * vec2(-1, -1)).rgb * 1;
    lowMip = texture(tex, texCoord + texel * radius * vec2(-1, 0)).rgb * 2;

    lowMip = texture(tex, texCoord).rgb * 4;

    lowMip /= 16;


    //FragColor += vec4(lowMip, 1) + texture(tex2, texCoord);
    FragColor = vec4(mix(texture(tex, texCoord), texture(tex2, texCoord), 0.4).rgb, 1);
}