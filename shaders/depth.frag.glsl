#version 450

out vec4 o_fragColor;
  

void main() {
    o_fragColor.r = 1 - gl_FragCoord.z;
    gl_FragDepth = 1 - gl_FragCoord.z;
}