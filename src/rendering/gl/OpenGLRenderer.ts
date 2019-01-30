import {mat4, vec4,vec3,vec2} from 'gl-matrix';
import Drawable from './Drawable';
import Camera from '../../Camera';
import {gl} from '../../globals';
import ShaderProgram from './ShaderProgram';

// In this file, `gl` is accessible because it is imported above
class OpenGLRenderer {
  constructor(public canvas: HTMLCanvasElement) {
  }

  setClearColor(r: number, g: number, b: number, a: number) {
    gl.clearColor(r, g, b, a);
  }

  setDepthTest(){
    gl.disable(gl.BLEND);
    gl.enable(gl.DEPTH_TEST);
  }

  setAlphaBlend(){
     // gl.disable(gl.DEPTH_TEST);
      gl.enable(gl.BLEND);
      gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
  }
  setSize(width: number, height: number) {
    this.canvas.width = width;
    this.canvas.height = height;
  }

  clear() {
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  }

  render(camera: Camera,
         prog: ShaderProgram,
         drawables: Array<Drawable>,
         powval : number,
         timer : number,
         sundir:vec3,
         waterele:number,
         winres : vec2,
         dens : number
  ) {


    let model = mat4.create();
    let viewProj = mat4.create();
    let color = vec4.fromValues(1, 0, 0, 1);

    mat4.identity(model);
    mat4.multiply(viewProj, camera.projectionMatrix, camera.viewMatrix);
    prog.setModelMatrix(model);
    prog.setViewProjMatrix(viewProj);
    prog.setPowVal(powval);
    prog.setShaderTime(timer);
    prog.setEyePos(camera.controls.eye);
    prog.setSunDir(sundir);
    prog.setWaterEle(waterele);
    prog.setWindRes(winres);
    prog.setCloudDens(dens);

    for (let drawable of drawables) {
      prog.draw(drawable);

    }
  }
};

export default OpenGLRenderer;
