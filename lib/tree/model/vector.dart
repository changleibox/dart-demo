import 'dart:math' as math;

class Vector {
  double _x;
  double _y;

  Vector(double x, double y)
      : _x = x ?? 0,
        _y = y ?? 0;

  factory Vector.fromAngle(double angle) {
    var x = math.cos(angle);
    var y = math.sin(angle);
    return Vector(x, y);
  }

  double get x => _x;

  double get y => _y;

  set x(double x) => _x = x;

  set y(double y) => _y = y;

  void setValue(double x, double y) {
    _x = x;
    _y = y;
  }

  void reset() {
    _x = 0;
    _y = 0;
  }

  void add(Vector vector) {
    _x += vector._x;
    _y += vector._y;
  }

  void sub(Vector vector) {
    _x -= vector._x;
    _y -= vector._y;
  }

  void mult(double scalar) {
    _x *= scalar;
    _y *= scalar;
  }

  void div(scalar) {
    _x /= scalar;
    _y /= scalar;
  }

  double dot(Vector vector) {
    return vector._x * _x + vector._y * _y;
  }

  void limit(double limitValue) {
    if (mag > limitValue) {
      mag = limitValue;
    }
  }

  double get mag => math.sqrt(math.pow(_x, 2) + math.pow(_y, 2));

  set mag(double newMag) {
    if (mag > 0) {
      normalize();
    } else {
      _x = 1;
      _y = 0;
    }
    mult(newMag);
  }

  void normalize() {
    var mag = this.mag;
    if (mag > 0) {
      _x /= mag;
      _y /= mag;
    }
  }

  double get heading => math.atan2(_y, _x);

  set heading(double angle) {
    var mag = this.mag;
    _x = math.cos(angle) * mag;
    _y = math.sin(angle) * mag;
  }

  double dist(Vector vector) => Vector(_x - vector._x, _y - vector._y).mag;

  double angle(Vector vector) => math.atan2(vector._y - _y, vector._x - _x);

  Vector copy() => Vector(_x, _y);
}
