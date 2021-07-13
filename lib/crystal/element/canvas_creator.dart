import 'dart:html';

import 'package:dart_demo/creator/creator.dart';

class CanvasCreator extends Creator {
  final CanvasElement _canvasElement;
  CanvasRenderingContext2D _context;

  CanvasCreator() : _canvasElement = CanvasElement() {
    _context = _canvasElement.context2D;
  }

  @override
  void build(Element element) {
    _context.imageSmoothingEnabled = false;
    element.children.clear();
    element.children.add(_canvasElement);

    window.requestAnimationFrame(modelvisitNumber);
  }

  void modelvisitNumber(num highResTime) {
    var width = _canvasElement.width, height = _canvasElement.height;
    _canvasElement.style.width = '${width}px';
    _canvasElement.style.height = '${height}px';
    _canvasElement.height = height * window.devicePixelRatio;
    _canvasElement.width = width * window.devicePixelRatio;

    _context.beginPath();
    _context.font = '14px Arial';
    _context.fillStyle = '#FF9000';
    _context.fillText('dart暂不支持threeDart', 40, 35);
    _context.stroke();
    _context.closePath();

    _context.stroke();
    _context.closePath();
    _context.scale(window.devicePixelRatio, window.devicePixelRatio);
  }
}
