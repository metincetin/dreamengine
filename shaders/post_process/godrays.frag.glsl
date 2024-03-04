#version 450

uniform sampler2D tex;
uniform sampler2D u_sceneTexture;
uniform sampler2D u_depthTexture;


in vec2 texCoord;
in vec4 color;



out vec4 FragColor;

void main(){
    vec4 main = texture(tex, texCoord);
    float depth = texture(u_depthTexture, texCoord).r;

    bool depthCut = depth >= 1;


    float grayscale = dot(main.rgb, vec3(0.299, 0.587, 0.114));
    grayscale = pow(grayscale, 10.0);

    FragColor = vec4(main.rgb * grayscale * vec3(depthCut), 1);
}
