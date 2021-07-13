import 'dart:html';
import 'dart:math' as math;

import 'vector.dart';

class Point {
  Vector position;
  Vector oldPosition;
  bool pinned;
  double angle;

  Point(double x, double y) {
    position = Vector(x, y);
    oldPosition = position.copy();
    pinned = false;
    angle = null;
  }

  void render(CanvasRenderingContext2D context) {
    context.beginPath();
    context.arc(position.x, position.y, 4, 0, 2 * math.pi);
    context.stroke();
  }
}
