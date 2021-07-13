import 'dart:html';
import 'dart:typed_data';
import 'dart:math' as math;

import 'dart:web_gl';

class Canvas {
  final CanvasElement element;
  final RenderingContext gl;
  Shader vertexShader;
  Shader fragmentShader;
  Program program;
  int position;
  UniformLocation umatrix;
  Buffer positionBuffer;
  Float32List matrix;
  Map<String, CanvasTexture> textures;
  String lastTexture;
  int frame;
  double width;
  double height;

  Canvas(this.element, this.gl);

  void init() {
    vertexShader = gl.createShader(WebGL.VERTEX_SHADER);
    gl.shaderSource(
      vertexShader,
      '''
        precision highp float;
        attribute vec2 aPosition;
        uniform mat3 uMatrix;
        varying vec2 vTexcoord;
        void main() {
					gl_Position = vec4(uMatrix * vec3(aPosition, 1), 1);
					vTexcoord = aPosition;
        }
      ''',
    );
    gl.compileShader(vertexShader);
    fragmentShader = gl.createShader(WebGL.FRAGMENT_SHADER);
    gl.shaderSource(
      fragmentShader,
      '''
        precision highp float;
        varying vec2 vTexcoord;
        uniform sampler2D texture;
        void main() {
           gl_FragColor = texture2D(texture, vTexcoord);
        }
      ''',
    );
    gl.compileShader(fragmentShader);
    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    // init attributes, uniforms and buffers
    position = gl.getAttribLocation(program, 'aPosition');
    gl.enableVertexAttribArray(position);
    umatrix = gl.getUniformLocation(program, 'uMatrix');
    positionBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.ARRAY_BUFFER, positionBuffer);
    gl.bufferData(
      WebGL.ARRAY_BUFFER,
      Float32List.fromList([0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1]),
      WebGL.STATIC_DRAW,
    );
    gl.vertexAttribPointer(position, 2, WebGL.FLOAT, false, 0, 0);
    // position/orientation/scaling 3x3 matrix
    matrix = Float32List(9);
    matrix[8] = 1;
    // textures
    textures = {};
    lastTexture = '';
    frame = 0;
    // source over blending
    gl.blendFunc(WebGL.SRC_ALPHA, WebGL.ONE_MINUS_SRC_ALPHA);
    gl.enable(WebGL.BLEND);
    gl.disable(WebGL.DEPTH_TEST);
    gl.useProgram(program);
    // resize event
    resize();
    window.addEventListener('resize', (event) => resize(), false);
  }

  CanvasTexture createImage(String id, dynamic src, bool loaded) {
    var tex = textures[id];
    if (tex != null) {
      return tex;
    }
    tex = textures[id] = CanvasTexture(id, src, loaded, gl);
    return tex;
  }

  void drawImage(
    CanvasTexture img,
    double x,
    double y, {
    double w,
    double h,
    double offsetX = 0,
    double offsetY = 0,
    double angle = 0,
  }) {
    w ??= img.width.toDouble();
    h ??= img.height.toDouble();
    if (!img.loaded) {
      return;
    }
    var m = matrix;
    var sx = 2 / width;
    var sy = -2 / height;
    if (angle != null && angle != 0 && angle != -0 && !angle.isNaN) {
      var c = math.cos(angle);
      var s = math.sin(angle);
      m[0] = c * sx * w;
      m[1] = s * sy * w;
      m[3] = -s * sx * h;
      m[4] = c * sy * h;
      m[6] = (c * offsetX - s * offsetY + x) * sx - 1;
      m[7] = (s * offsetX + c * offsetY + y) * sy + 1;
    } else {
      m[0] = sx * w;
      m[1] = 0;
      m[3] = 0;
      m[4] = sy * h;
      m[6] = (offsetX + x) * sx - 1;
      m[7] = (offsetY + y) * sy + 1;
    }
    gl.uniformMatrix3fv(umatrix, false, m);
    // bind texture
    if (img.id != lastTexture) {
      lastTexture = img.id;
      gl.bindTexture(WebGL.TEXTURE_2D, img.texture);
    }
    // draw the quad
    gl.drawArrays(WebGL.TRIANGLES, 0, 6);
  }

  void resize() {
    width = (element.width = element.offsetWidth).toDouble();
    height = (element.height = element.offsetHeight).toDouble();
    // set viewport
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
  }
}

class CanvasTexture {
  final String id;
  bool loaded;
  double width;
  double height;
  Texture texture;
  double x;
  double y;
  double radius;
  double m;

  CanvasTexture(
    this.id,
    dynamic src,
    this.loaded,
    RenderingContext gl,
  )   : width = loaded ? src.width : 0,
        height = loaded ? src.height : 0,
        texture = loaded ? createTexture(src, gl) : null {
    if (!loaded) {
      var source = ImageElement();
      source.onLoad.listen((event) {
        loaded = true;
        width = source.width.toDouble();
        height = source.height.toDouble();
        texture = createTexture(source, gl);
      });
      source.src = src;
    }
  }

  static Texture createTexture(dynamic source, RenderingContext gl) {
    var texture = gl.createTexture();
    gl.bindTexture(WebGL.TEXTURE_2D, texture);
    // assume non power of 2
    gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
    gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
    gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.LINEAR);
    gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.LINEAR);
    // upload texture to gpu
    gl.texImage2D(WebGL.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA, WebGL.UNSIGNED_BYTE, source);
    return texture;
  }
}
