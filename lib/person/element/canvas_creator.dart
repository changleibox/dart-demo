import 'dart:html';
import 'dart:math' as math;
import 'dart:web_gl' as web_gl;

import 'package:dart_demo/creator/creator.dart';
import 'package:dart_demo/person/model/canvas.dart';
import 'package:dart_demo/person/model/human.dart';
import 'package:dart_demo/person/model/pointer.dart';
import 'package:dart_demo/person/model/struct.dart';

class CanvasCreator extends Creator {
  final CanvasElement _canvasElement;
  web_gl.RenderingContext _context;
  Canvas _canvas;
  Pointer _pointer;
  CanvasTexture _ball;
  List<Human> _humans;
  StructPoint _hook;

  CanvasCreator() : _canvasElement = CanvasElement() {
    _context = _canvasElement.getContext3d(
      alpha: false,
      stencil: false,
      antialias: false,
      depth: false,
    );
  }

  @override
  void build(Element element) {
    element.children.clear();
    element.children.add(_canvasElement);

    if (_context == null) {
      return;
    }
    _canvas = Canvas(_canvasElement, _context)..init();
    _pointer = Pointer()..init(_canvas);
    _humans = _createHumans();
    _ball = _createBall();
    _hook = StructPoint(x: 0, y: 0, m: 100);
    window.requestAnimationFrame(_run);
  }

  void _run(num highResTime) {
    window.requestAnimationFrame(_run);
    // clear screen
    _context.clearColor(0.92, 0.68, 0, 1);
    _context.clear(web_gl.WebGL.COLOR_BUFFER_BIT);
    // ease pointer
    _pointer.ease(0.33);
    // animate humans
    for (var human in _humans) {
      human.anim(_ball);
      _hook.x = human.x * _canvas.width;
      _hook.y = human.y * _canvas.height;
      human.points[16].join(_hook, 0, 1);
      if (_pointer.isDown) {
        human.points[16].join(_ball, _ball.radius, 1);
      }
    }
    // webgl rendering
    if (_canvas.frame++ > 10) {
      // draw ball
      _ball.x = _pointer.ex;
      _ball.y = _pointer.ey;
      _canvas.drawImage(_ball, _ball.x - _ball.radius, _ball.y - _ball.radius);
      for (var human in _humans) {
        human.draw();
      }
    }
  }

  CanvasTexture _createBall() {
    var ball = CanvasElement();
    var radius = 0.3 * math.min(_canvas.width, _canvas.height);
    ball.width = ball.height = 2 * radius.floor();
    var ctx = ball.getContext('2d') as CanvasRenderingContext2D;
    ctx.beginPath();
    ctx.arc(radius, radius, radius * 0.99, 0, 2 * math.pi);
    ctx.fillStyle = '#222';
    ctx.fill();
    var shape = _canvas.createImage('ball', ball, true);
    shape.radius = radius;
    shape.m = 1000;
    return shape;
  }

  List<Human> _createHumans() {
    var humans = <Human>[];
    var s = _canvas.height * 0.075;
    var n = 0.2 * _canvas.width / s;
    for (var i = 0; i < n; ++i) {
      humans.add(Human(
        size: s,
        gravity: 0.2,
        x: i / n,
        y: 0,
        struct: struct,
        canvas: _canvas,
      ));
    }
    return humans;
  }
}
