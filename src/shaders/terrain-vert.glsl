#version 300 es


uniform mat4 u_Model;
uniform mat4 u_ModelInvTr;
uniform mat4 u_ViewProj;
uniform vec2 u_PlanePos; // Our location in the virtual world displayed by the plane
uniform float u_powval;

in vec4 vs_Pos;
in vec4 vs_Nor;
in vec4 vs_Col;

out vec3 fs_Pos;
out vec3 fs_Nor;
out vec4 fs_Col;

out float fs_Sine;

float random1( vec2 p , vec2 seed) {
  return fract(sin(dot(p + seed, vec2(127.1, 311.7))) * 43758.5453);
}

float random1( vec3 p , vec3 seed) {
  return fract(sin(dot(p + seed, vec3(987.654, 123.456, 531.975))) * 85734.3545);
}

vec2 random2( vec2 p , vec2 seed) {
  return fract(sin(vec2(dot(p + seed, vec2(311.7, 127.1)), dot(p + seed, vec2(269.5, 183.3)))) * 85734.3545);
}

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}



//worly noise
float r(float n)
{
	return fract(cos(n*89.42)*343.42);
}
vec2 r(vec2 n)
{
	return vec2(r(n.x*23.62 - 300.0 + n.y*34.35), r(n.x*45.13 + 256.0 + n.y*38.89));
}
float worley(vec2 n, float s)
{
	n *= 25.f;
	float dis = 20.0;
	for (int x = -1; x <= 1; x++)
	{
		for (int y = -1; y <= 1; y++)
		{
			vec2 p = floor(n / s) + vec2(x, y);
			float d = length(r(p) + vec2(x, y) - fract(n / s));
			if (dis > d)
			{
			    float rd = random(p);
				dis = d;
			}
		}
	}
	return dis;

}
//worly noise
#define OCTAVES 6
#define OCTBIO 1

float biofbm (in vec2 st) {
      // Initial values
      float value = 0.0;
      float amplitude = .5;
      float frequency = 0.;
      //
      // Loop of octaves
      for (int i = 0; i < OCTBIO; i++) {
          value += amplitude * noise(st);
          st *= 1.7;
          amplitude *= .5;
      }
      //value = pow(value,2.0/2.0);//pow rmapping
      //value = exp(value);
      return value;
    }

float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .2;
    float frequency = 0.;
    //
    // Loop of octaves
    float pre = worley(st,68.f);
    float large = worley(st*2.0,48.f);
    value += pre/1.2 + large/5.0;
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);//worley(st,48.f);
        st *= 2.;
        amplitude *= .5;
    }
    //if(value<0.2) value = pow(value,10.0);

    //value = exp(value);

    float biov = biofbm(st*0.004);
    float biovm = biofbm((st+vec2(0.2,1.92))*0.0004);

    float deserth = 0.1;

    float normalh = 1.0;

    float mtnh = 2.5;

    float hightmask = 1.0;


    value-=pow(biov,1.8);

    value+=pow(biov,0.9);

    float mask = 1.3*worley(st,8248.f) ;
    value*=mask;
    value = pow(value,u_powval );//pow rmapping
    return value;
}




void main()
{
  fs_Pos = vs_Pos.xyz;
  float hscale = 18.0;
  //fs_Sine = (sin((vs_Pos.x + u_PlanePos.x) * 3.14159 * 0.1) + cos((vs_Pos.z + u_PlanePos.y) * 3.14159 * 0.1));
  vec2 pp = vec2(vs_Pos.x+ u_PlanePos.x,vs_Pos.z+ u_PlanePos.y);
  vec2 ppr = vec2(vs_Pos.x + 1.0f + u_PlanePos.x,vs_Pos.z+ u_PlanePos.y);
  vec2 ppb = vec2(vs_Pos.x+ u_PlanePos.x,vs_Pos.z + 1.0f + u_PlanePos.y);
  float r = fbm(ppr/10.0f);
  float b = fbm(ppb/10.0f);
  fs_Sine = fbm(pp/10.f);

  vec4 modelposition = vec4(vs_Pos.x, fs_Sine * hscale, vs_Pos.z, 1.0);

  fs_Pos = vec3(modelposition);

  vec3 nor = cross(vec3(modelposition)-vec3(vs_Pos.x+ 1.0f,hscale*b,vs_Pos.z),vec3(modelposition)-vec3(vs_Pos.x,hscale*r,vs_Pos.z+ 1.0f));
  fs_Nor = -normalize(nor);



  modelposition = u_Model * modelposition;
  gl_Position = u_ViewProj * modelposition;
}
