#version 300 es
precision highp float;

uniform vec2 u_PlanePos; // Our location in the virtual world displayed by the plane
uniform float u_Time;
uniform vec3 u_EyePos;
uniform vec3 u_SunDir;
uniform float u_WaterEle;
uniform float u_CloudDens;

in vec3 fs_Pos;
in vec3 fs_Nor;
in vec4 fs_Col;
in float hscale;

in float fs_Sine;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.

float bias(float b, float t)
{
    return pow(t,log(b)/log(0.5f));
}

void main()
{

    float clouddens = u_CloudDens;

    float t = clamp(smoothstep(80.0, 120.0, length(fs_Pos)), 0.0, 1.0); // Distance fog
    vec3 acol = vec3(0.0);
    float ina = fs_Pos.y/hscale;
    acol = vec3(ina,ina,ina);
    //out_Col = vec4(mix(fcol.xyz, vec3(164.0 / 255.0, 233.0 / 255.0, 1.0), t), mix(fcol.w,1.0,t));
    float a = 0.5;

    a = 1.0-(fs_Pos.y/hscale -0.33);
     if(fs_Pos.y/hscale>clouddens) a = 0.0;
     a = pow(a,3.1);
    //out_Col = vec4(1.2-acol,a);
    out_Col = vec4(mix(1.2-acol, vec3(164.0 / 255.0, 233.0 / 255.0, 1.0), t), mix(a,1.0,t));
}
