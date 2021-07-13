import 'dart:html';

import 'package:dart_demo/creator/creator.dart';
import 'package:dart_demo/tree/model/plant.dart';
import 'package:dart_demo/tree/model/vector.dart';
import 'package:dart_demo/tree/model/wind.dart';
import 'package:dart_demo/tree/resource/colors.dart';
import 'package:dart_demo/tree/util/utils.dart';

class CanvasCreator extends Creator {
  final CanvasElement _canvasElement;
  CanvasRenderingContext2D _context;
  List<Plant> _plants;
  int _width;
  int _height;
  Vector _mouse;
  final Wind _wind = Wind()..reset();
  final Vector _gravity = Vector(0, 0.6);

  CanvasCreator() : _canvasElement = CanvasElement() {
    _context = _canvasElement.context2D;
  }

  @override
  void build(Element element) {
    element.children.clear();
    element.children.add(_canvasElement);
    _setSize();

    window.onResize.listen((event) {
      _setSize();
      _populate();
    });

    _mouse = Vector(_width.toDouble() / 2, _height.toDouble() / 2);
    _canvasElement.onMouseMove.listen((event) {
      _mouse.x = event.client.x - _canvasElement.offsetLeft;
      _mouse.y = event.client.y - _canvasElement.offsetTop;
    });

    _wind.reset();
    _populate();
    _loop(0);
  }

  void _setSize() {
    _width = _canvasElement.width = window.innerWidth;
    _height = _canvasElement.height = window.innerHeight;
    _context.lineCap = 'round';
    _context.lineJoin = 'round';
  }

  void _populate() {
    _plants = [];
    var divX = 4;
    var divY = 5;
    var totalDiv = divX * divY;
    // var partX = _width / divX;

    for (var i = 0; i < totalDiv; i++) {
      var offsetX = random(0, _width);
      var offsetY = (i / divX).floor();
      var zValue = map(offsetY, 0, divY - 1, 0.8, 0);
      var pLength = map(offsetY, 0, divY - 1, _height * 0.4, _height);

      var zRandom = random(0.8, 1.2);
      zValue *= zRandom;
      zValue = clamp(zValue, 0, 1);
      var plant = Plant(offsetX, 0, pLength, _height);
      plant.setZValue = zValue;
      plant.init();
      _plants.add(plant);
    }
  }

  void _loop(num highResTime) {
    _context.fillStyle = backgroundColor;
    _context.fillRect(0, 0, _width, _height);
    _wind.update();
    _plants.forEach((element) {
      element.update(_height, _wind, _gravity, _mouse);
      element.render(_context);
    });
    window.requestAnimationFrame(_loop);
  }
}
