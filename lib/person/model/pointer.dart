import 'dart:html';

import 'canvas.dart';

class Pointer {
  double x;
  double y;
  double ex;
  double ey;
  bool isDown;

  void init(Canvas canvas) {
    x = canvas.width * 0.5;
    y = canvas.height * 0.75;
    ex = x;
    ey = canvas.height * 2;
    isDown = false;
    window.addEventListener('mousemove', _move, false);
    canvas.element.addEventListener('touchmove', _move, false);
    window.addEventListener('mousedown', (event) => {isDown = true}, false);
    window.addEventListener('mouseup', (event) => {isDown = false}, false);
  }

  void _move(Event event) {
    if (event is TouchEvent) {
      event.preventDefault();
      var targetTouche = event.targetTouches[0];
      x = targetTouche.client.x;
      y = targetTouche.client.y;
    } else if (event is MouseEvent) {
      x = event.client.x;
      y = event.client.y;
    }
  }

  void ease(double n) {
    ex += (x - ex) * n;
    ey += (y - ey) * n;
  }
}
