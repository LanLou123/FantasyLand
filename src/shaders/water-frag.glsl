#version 300 es
precision highp float;

uniform vec2 u_PlanePos; // Our location in the virtual world displayed by the plane
uniform float u_Time;
uniform vec3 u_EyePos;
uniform vec3 u_SunDir;
uniform float u_WaterEle;

in vec3 fs_Pos;
in vec3 fs_Nor;
in vec4 fs_Col;

in float fs_Sine;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.

float bias(float b, float t)
{
    return pow(t,log(b)/log(0.5f));
}

void main()
{

    vec3 vd = normalize(-fs_Pos+u_EyePos);
    vec3 lightdir = normalize(u_SunDir);
    vec3 halfwaydir =normalize(lightdir+ vd);
    float spec = pow(max(0.0,dot(halfwaydir,normalize(fs_Nor))),1600.f);
    float lambert = dot(fs_Nor,lightdir);
    float t = clamp(smoothstep(80.0, 120.0, length(fs_Pos)), 0.0, 1.0); // Distance fog
    vec3 acol = vec3(0.0);
    acol = lambert*mix(vec3(0.0,0.14,0.45),vec3(0,0.35,0.5),fs_Pos.y/0.3) + vec3(1,1,1)*spec;

    float fbias = -0.1;
    float fpow = 15.0;
    float fscale = 1.0;

    float R = max(0.0, min(1.0, fbias + fscale * pow(1.0 + dot(vd, -fs_Nor), fpow)));//emperical fresnel

    float a = mix(0.0,1.0,u_WaterEle-fs_Pos.y*0.4);
    vec3 clearcol = vec3(164.0/255.0, 233.0/255.0, 1.0);
    vec3 fresnel = R*clearcol;
    vec4 fcol = vec4(acol+fresnel,a);
    out_Col = vec4(mix(fcol.xyz, vec3(164.0 / 255.0, 233.0 / 255.0, 1.0), t), mix(fcol.w,1.0,t));
    //out_Col = vec4(R,R,R,1.0);
}
