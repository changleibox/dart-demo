import 'dart:html';
import 'dart:math' as math;

import 'package:dart_demo/tree/resource/colors.dart';
import 'package:dart_demo/tree/util/utils.dart';

import 'point.dart';

class Leaf {
  Point parent;
  Point end;
  double zValue;
  List<String> colors;
  String trueColor;
  double size;
  double thickness;
  String color;

  Leaf(Point parent, double length) {
    this.parent = parent;
    end = Point(parent.position.x, parent.position.y + (length * random(0.9, 1.1)));
    end.angle = 0;
    zValue = 0;
    colors = ['#2c4c28', '#48792c', '#69982d'];
    trueColor = colors[(math.Random().nextDouble() * colors.length).floor()];
    size = (length * 2) * random(0.8, 1.2);
    thickness = size * 0.5 * random(0.6, 1.2);
  }

  void setZValue(double zValue) {
    this.zValue = zValue;
    color = lerpColor(trueColor, backgroundColor, zValue);
  }

  void render(CanvasRenderingContext2D context) {
    context.strokeStyle = color;
    context.beginPath();
    context.moveTo(parent.position.x, parent.position.y);
    context.lineTo(end.position.x, end.position.y);
    context.closePath();
    context.stroke();
  }
}
