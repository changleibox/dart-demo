import 'package:dart_demo/tree/util/tween.dart';
import 'package:dart_demo/tree/util/utils.dart';

import 'vector.dart';

class Wind {
  Vector value = Vector(0, 0.0);
  DateTime timeStart = DateTime.now();
  double start;
  double duration;
  double goal;

  void reset() {
    timeStart = DateTime.now();
    start = value.x;
    duration = random(200, 1000);
    goal = random(-0.06, 0.06);
  }

  void update() {
    var time = DateTime.now().millisecondsSinceEpoch - timeStart.millisecondsSinceEpoch;
    if (time < duration) {
      value.x = linear(time, start, goal - start, duration);
    } else {
      var delayedDuration = Duration(milliseconds: random(100, 3000).floor());
      Future.delayed(delayedDuration).whenComplete(() => reset());
    }
  }
}
