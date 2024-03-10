#version 450

uniform sampler2D u_texture;
in vec2 texCoord;
out vec4 o_fragColor;
  

void main() {
    float a = texture(u_texture, texCoord).a;
    if (a < 0.5) discard;
    o_fragColor.r = 1 - gl_FragCoord.z;
    gl_FragDepth = 1 - gl_FragCoord.z;
}