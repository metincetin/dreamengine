#version 450
//https://www.shadertoy.com/view/Ml2cWG


in vec3 normal;
in vec4 color;
in mat4 view;
in vec2 texCoord;
in vec3 Position_World;

uniform mat4 MVP;
uniform mat4 Model;
uniform mat4 V;
uniform vec3 cameraPosition;

uniform vec2 resolution;


out vec4 FragColor;

#include "include/lighting.inc.glsl"
#include "include/common.inc.glsl"

const float invPi = 1.0 / PI;

const float zenithOffset = 0.1;
const float multiScatterPhase = 0.1;
const float density = 0.7;

const float anisotropicIntensity = 0.0; //Higher numbers result in more anisotropic scattering

const vec3 skyColor = vec3(0.39, 0.57, 1.0) * (1.0 + anisotropicIntensity); //Make sure one of the conponents is never 0.0

#define smooth(x) x*x*(3.0-2.0*x)
#define zenithDensity(x) density / pow(max(x - zenithOffset, 0.35e-2), 0.75)

vec3 getSkyAbsorption(vec3 x, float y){
	
	vec3 absorption = x * -y;
	     absorption = exp2(absorption) * 2.0;
	
	return absorption;
}

float getSunPoint(vec2 p, vec2 lp){
	return smoothstep(0.03, 0.026, distance(p, lp)) * 50.0;
}

float getRayleigMultiplier(vec2 p, vec2 lp){
	return 1.0 + pow(1.0 - clamp(distance(p, lp), 0.0, 1.0), 2.0) * PI * 0.5;
}

float getMie(vec2 p, vec2 lp){
	float disk = clamp(1.0 - pow(distance(p, lp), 0.1), 0.0, 1.0);
	
	return disk*disk*(3.0 - 2.0 * disk) * 2.0 * PI;
}

vec3 getAtmosphericScattering(vec2 p, vec2 lp){
	vec2 correctedLp = lp / max(resolution.x, resolution.y) * resolution.xy;
		
	float zenith = zenithDensity(p.y);
	float sunPointDistMult =  clamp(length(max(correctedLp.y + multiScatterPhase - zenithOffset, 0.0)), 0.0, 1.0);
	
	float rayleighMult = getRayleigMultiplier(p, correctedLp);
	
	vec3 absorption = getSkyAbsorption(skyColor, zenith);
    vec3 sunAbsorption = getSkyAbsorption(skyColor, zenithDensity(correctedLp.y + multiScatterPhase));
	vec3 sky = skyColor * zenith * rayleighMult;
	vec3 sun = getSunPoint(p, correctedLp) * absorption;
	vec3 mie = getMie(p, correctedLp) * sunAbsorption;
	
	vec3 totalSky = mix(sky * absorption, sky / (sky + 0.5), sunPointDistMult);
         totalSky += sun + mie;
	     totalSky *= sunAbsorption * 0.5 + 0.5 * length(sunAbsorption);
	
	return totalSky;
}

vec3 jodieReinhardTonemap(vec3 c){
    float l = dot(c, vec3(0.2126, 0.7152, 0.0722));
    vec3 tc = c / (c + 1.0);

    return mix(c / (l + 1.0), tc, tc);
}

vec2 DirectionToTexCoord(vec3 direction) {
    // Calculate polar coordinates
    float azimuth = atan(direction.y, direction.x);
    float inclination = acos(direction.z);

    // Map polar coordinates to texture coordinates
    float u = (azimuth + PI) / (2.0 * PI);
    float v = inclination / PI;

    return vec2(u, v);
}

void main(){

	vec2 position = texCoord;
	vec2 lightPosition = DirectionToTexCoord(GetMainLightDirection());
	
	vec3 color = getAtmosphericScattering(position, lightPosition) * PI;
	color = jodieReinhardTonemap(color);
 	color = pow(color, vec3(2.2)); //Back to linear
	
	FragColor = vec4(color, 1.0);
}