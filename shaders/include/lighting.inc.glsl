uniform vec3 _DirectionalLightColor;
uniform vec3 _DirectionalLightDirection;

uniform vec3 additionalLight0_color = vec3(1);
uniform float additionalLight0_attenuation;
uniform vec3 additionalLight0_position;
uniform vec4 _AmbientColor;

#define PI 3.141592653589793238462643383279502884197
#include "common.inc.glsl"

vec3 GetMainLightDirection(){
    return _DirectionalLightDirection;
}
vec3 GetMainLightColor(){
    return _DirectionalLightColor;
}

float chiGGX(float v)
{
    return v > 0.0 ? 1.0 : 0.0;
}

float G_GGX(vec3 v, vec3 n, vec3 h, float alpha)
{
    float VoH2 = clamp(dot(v,h), 0, 1);
    float chi = chiGGX( VoH2 / clamp(dot(v,n), 0, 1) );
    VoH2 = VoH2 * VoH2;
    float tan2 = ( 1 - VoH2 ) / VoH2;
    return (chi * 2) / ( 1 + sqrt( 1 + alpha * alpha * tan2 ) );
}

float D_GGX(vec3 N, vec3 H, float roughness){
    float a = roughness * roughness;
    float a2 = a*a;

    float ndh = max(0,dot(N,H));
    float ndh2 = ndh * ndh;

    float den = PI * ((ndh2) * (a2 - 1) + 1);
    den *= den;

    den = max(den, 0.00000001);

    return a2 / (den);
}


vec3 SchlickFresnel(vec3 V, vec3 H, vec3 F0){
   return F0 + (vec3(1) - F0) * pow( 1 - max(dot(V,H), 0.05), 5);
}

vec3 CookTorrance(vec3 H, vec3 V, vec3 N, vec3 L, float roughness, vec3 F0){
    float vdn = max(0.05, dot(V, N));
    float vdh = max(0.0, dot(V, H));
    float hdn = max(0.0, dot(H, N));
    float ldn = max(0.0, dot(L, N));



    vec3 f = SchlickFresnel(V, N, F0);

    float g = G_GGX(V, N, H, roughness);
    float d = D_GGX(N, H, roughness);

    return (d * f * g) / max(0.00001,(4 * vdn * ldn));
}


vec3 BRDF(vec3 lambert, vec3 N, vec3 L, vec3 V, vec3 H, float roughness){


	float ior = 1.4 + 1;

	vec3 F0 = vec3(abs((1.0 - ior) / (1.0 + ior)));
	F0 = F0 * F0;
	F0 = mix(F0, vec3(1.0, 0, 0), 0);


    //vec3 Ks = vec3(0);//SchlickFresnel(V, H, F0);
    vec3 Ks = SchlickFresnel(V, H, F0);
    vec3 Kd = vec3(1.0) - Ks;
    
    vec3 spec = CookTorrance(H, V, N, L, roughness,F0);

    return Kd * lambert + spec;
}

vec3 PBR(vec3 color, vec3 lightColor, vec3 N, vec3 L, vec3 V, float roughness){
    vec3 H = normalize(L + V);

    vec3 lambert = color;

    return BRDF(lambert, N, L, V, H, roughness) * max(dot(L, N), 0);
}


vec3 applyDistanceFog(vec3 base, vec3 fogColor, float density, float factor){
    float fac = clamp(1.0 - exp(-density * factor), 0, 1);
    return mix(base, fogColor, fac);
}

// A fog opacity
vec3 applyHeightFog(vec3 base, vec4 fogColor, float start, float end, float h){
    float t = (h - start) / (end - start);
    t = clamp(t, 0, 1);
    t = 1 - t;


    return mix(base, fogColor.xyz, t * fogColor.a);
}