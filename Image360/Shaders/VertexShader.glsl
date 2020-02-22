//
//  VertexShader.glsl
//  Image360
//

attribute vec4 aPosition;
attribute vec2 aUV;
uniform mat4 uProjection;
uniform mat4 uView;
uniform mat4 uModel;
varying vec2 vUV;
void main() {
  gl_Position = uProjection * uView * uModel * aPosition;
  vUV = aUV;
}
