import 'dart:math' as math;

class Vector {
  double x;
  double y;

  Vector(double x, double y)
      : x = x ?? 0,
        y = y ?? 0;

  factory Vector.fromAngle(double angle) {
    var x = math.cos(angle);
    var y = math.sin(angle);
    return Vector(x, y);
  }

  void setValue(double x, double y) {
    this.x = x;
    this.y = y;
  }

  void reset() {
    x = 0;
    y = 0;
  }

  void add(Vector vector) {
    x += vector.x;
    y += vector.y;
  }

  void sub(Vector vector) {
    x -= vector.x;
    y -= vector.y;
  }

  void mult(double scalar) {
    x *= scalar;
    y *= scalar;
  }

  void div(scalar) {
    x /= scalar;
    y /= scalar;
  }

  double dot(Vector vector) {
    return vector.x * x + vector.y * y;
  }

  void limit(double limitValue) {
    if (mag > limitValue) {
      mag = limitValue;
    }
  }

  double get mag => math.sqrt(math.pow(x, 2) + math.pow(y, 2));

  set mag(double newMag) {
    if (mag > 0) {
      normalize();
    } else {
      x = 1;
      y = 0;
    }
    mult(newMag);
  }

  void normalize() {
    var mag = this.mag;
    if (mag > 0) {
      x /= mag;
      y /= mag;
    }
  }

  double get heading => math.atan2(y, x);

  set heading(double angle) {
    var mag = this.mag;
    x = math.cos(angle) * mag;
    y = math.sin(angle) * mag;
  }

  double dist(Vector vector) => Vector(x - vector.x, y - vector.y).mag;

  double angle(Vector vector) => math.atan2(vector.y - y, vector.x - x);

  Vector copy() => Vector(x, y);
}
