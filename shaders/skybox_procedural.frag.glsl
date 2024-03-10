#version 450
//https://github.com/shff/opengl_sky


in vec3 normal;
in vec4 color;
in mat4 view;
in vec2 texCoord;

uniform mat4 MVP;
uniform mat4 Model;
uniform mat4 V;

#include "include/lighting.inc.glsl"


in vec3 pos;

out vec4 FragColor;

const float cirrus = 0.4;
const float cumulus = 0.6;

const float Br = 0.0025;
const float Bm = 0.0003;
const float g =  0.9800;
const vec3 nitrogen = vec3(0.650, 0.570, 0.475);
const vec3 Kr = Br / pow(nitrogen, vec3(4.0));
const vec3 Km = Bm / pow(nitrogen, vec3(0.84));

float hash(float n)
{
	return fract(sin(n) * 43758.5453123);
}

float noise(vec3 x)
{
	vec3 f = fract(x);
	float n = dot(floor(x), vec3(1.0, 157.0, 113.0));
	return mix(mix(mix(hash(n +   0.0), hash(n +   1.0), f.x),
					mix(hash(n + 157.0), hash(n + 158.0), f.x), f.y),
				mix(mix(hash(n + 113.0), hash(n + 114.0), f.x),
					mix(hash(n + 270.0), hash(n + 271.0), f.x), f.y), f.z);
	}

	const mat3 m = mat3(0.0, 1.60,  1.20, -1.6, 0.72, -0.96, -1.2, -0.96, 1.28);
	float fbm(vec3 p)
	{
	float f = 0.0;
	f += noise(p) / 2; p = m * p * 1.1;
	f += noise(p) / 4; p = m * p * 1.2;
	f += noise(p) / 6; p = m * p * 1.3;
	f += noise(p) / 12; p = m * p * 1.4;
	f += noise(p) / 24;
	return f;
}

void main(){

	vec3 fsun = -GetMainLightDirection();
	vec3 p = normalize(normal);

	vec3 sunColor = GetMainLightColor();

	// Atmosphere Scattering
	float mu = dot(normalize(p), normalize(fsun));
	float rayleigh = 3.0 / (8.0 * 3.14) * (1.0 + mu * mu);
	vec3 mie = (Kr + Km * (1.0 - g * g) / (2.0 + g * g) / pow(1.0 + g * g - 2.0 * g * mu, 1.5)) / (Br + Bm);


	vec3 day_extinction = exp(-exp(-((p.y + fsun.y * 4.0) * (exp(-p.y * 16.0) + 0.1) / 80.0) / Br) * (exp(-p.y * 16.0) + 0.1) * Kr / Br) * exp(-p.y * exp(-p.y * 8.0 ) * 4.0) * exp(-p.y * 2.0) * 4.0;
	vec3 night_extinction = vec3(1.0 - exp(fsun.y)) * 0.2;
	vec3 extinction = mix(day_extinction, night_extinction, -fsun.y * 0.2 + 0.5);
	FragColor.rgb = rayleigh * mie * extinction;

	// Dithering Noise
	FragColor.rgb += noise(p* 1000) * 0.01;
	FragColor.xyz = FragColor.xyz / (FragColor.xyz + vec3(1.0));
	FragColor.xyz = pow(FragColor.xyz, vec3(1.0/2.2));

	if (p.y < 0)
	{
		FragColor.rgb *= smoothstep(-0.5, 0, p.y);
		FragColor.rgb = vec3(0);
	}

	FragColor.rgb = max(vec3(0), FragColor.rgb);
}