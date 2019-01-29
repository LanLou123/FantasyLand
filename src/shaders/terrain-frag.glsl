#version 300 es
precision highp float;

uniform vec2 u_PlanePos; // Our location in the virtual world displayed by the plane
uniform vec3 u_SunDir;
uniform float u_WaterEle;

in vec3 fs_Pos;
in vec3 fs_Nor;
in vec4 fs_Col;

in float fs_Sine;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.


//fbm================================================
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

#define OCTAVES 10
float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 1.7;
        amplitude *= .5;
    }
    value = pow(value,2.0/2.0);//pow rmapping
    //value = exp(value);
    return value;
}

void main()
{
    vec3 lightdir = normalize(u_SunDir);
    float lambert = dot(fs_Nor,lightdir);
    float t = clamp(smoothstep(80.0, 120.0, length(fs_Pos)), 0.0, 1.0); // Distance fog

    float bioval = fbm(vec2((fs_Pos.x+u_PlanePos.x)*0.04,(fs_Pos.z+u_PlanePos.y)*0.04));


    vec3 snow = vec3(1.0,1.0,1.0);
    vec3 rock = vec3(112.0/255.0,128.0/255.0,144.0/255.0);
    vec3 mud = vec3(244.0/255.0,164.0/255.0,96.0/255.0);
    vec3 forest = vec3(0.0,0.54,0.0);
    vec3 sand = vec3(255.0/255.0,250.0/255.0,205.0/255.0);
    vec3 deepocean = vec3(0.0,0.1,0.3);
    vec3 desert = vec3(210.0/255.0,180.0/255.0,140.0/255.0);

    vec3 acol = vec3(0.0);
    if(fs_Pos.y<u_WaterEle&&fs_Pos.y>=0.0)
    acol = mix(deepocean,sand,fs_Pos.y/u_WaterEle);
    if(fs_Pos.y>u_WaterEle&&fs_Pos.y<10.0)
    acol = mix(sand,forest,(fs_Pos.y-u_WaterEle)/(10.0-u_WaterEle));
    else if(fs_Pos.y>=10.0&&fs_Pos.y<=25.0){
    acol = mix(forest,rock,(fs_Pos.y - 10.0)/15.0);
    if(fs_Nor.y<0.4)
    acol = rock;
    }

    acol = mix(acol,desert,pow(bioval,0.8));


    if(fs_Nor.y>0.8&&fs_Pos.y>10.0)
         acol = snow;

    vec3 col1 = lambert*acol;
    //col1 = vec3(bioval,bioval,bioval);
    //out_Col = vec4(mix(vec3((fs_Sine)), vec3(164.0 / 255.0, 233.0 / 255.0, 1.0), t), 1.0);

    out_Col = vec4(mix(col1, vec3(164.0 / 255.0, 233.0 / 255.0, 1.0), t), 1.0);

    //out_Col = vec4(col1,1);
}
