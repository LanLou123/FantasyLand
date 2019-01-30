#version 300 es
precision highp float;


uniform vec3 u_SunDir;
uniform vec3 u_EyePos;
uniform vec2 u_WinRes;
uniform mat4 u_ViewProj;
// The fragment shader used to render the background of the scene
// Modify this to make your background more interesting

out vec4 out_Col;

void main() {

  vec2 uv = gl_FragCoord.xy/u_WinRes.xy;
      uv = uv * 2.0 - 1.0;
      uv.x *= u_WinRes.x / u_WinRes.y;
      vec3 rd = normalize(vec3(uv,1.0));
      vec3 ld = normalize(vec3(u_ViewProj*vec4(u_SunDir,0.0)));
      //vec3 rayDir = normalize(vec3(uv, 1.0 - dot(uv,uv) * 0.3));
      vec3 normcol = vec3(164.0 / 255.0, 233.0 / 255.0, 1.0);
      vec2 x=gl_FragCoord.xy;
	  //vec3 a=vec3(max((fract(dot(sin(x),x))-.99)*90.,.0));
      vec3 sun = mix(normcol,vec3(1.0,.9,.5),pow(max(0.0,dot(rd,ld)),10.0));

  out_Col = vec4(sun, 1.0);
}
