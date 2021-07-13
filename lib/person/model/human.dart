import 'dart:html';
import 'dart:math' as math;

import 'canvas.dart';
import 'struct.dart';

class Human {
  final double x;
  final double y;
  final List<HumanPoint> points;
  final List<HumanConstraint> constraints;
  final List<HumanAngle> angles;
  final List<HumanShape> shapes;

  Human({
    double size,
    double gravity,
    this.x,
    this.y,
    Struct struct,
    Canvas canvas,
  })  : points = <HumanPoint>[],
        constraints = <HumanConstraint>[],
        angles = <HumanAngle>[],
        shapes = <HumanShape>[] {
    for (var point in struct.points) {
      var humanPoint = HumanPoint(
        canvas.width * x,
        canvas.height * y,
        point,
        size,
        gravity,
      );
      points.add(humanPoint);
    }

    for (var constraint in struct.constraints) {
      var p0 = points[constraint.p0];
      var p1 = points[constraint.p1];
      constraints.add(HumanConstraint(p0, p1, constraint));
      if (constraint.svg != null) {
        shapes.add(HumanShape(
          p0,
          p1,
          constraint,
          struct.svg[constraint.svg],
          size,
          canvas,
        ));
      }
    }

    for (var angle in struct.angles) {
      angles.add(HumanAngle(
        points[angle.p0],
        points[angle.p1],
        points[angle.p2],
        angle,
      ));
    }
  }

  void anim(CanvasTexture ball) {
    for (var point in points) {
      point.integrate();
    }
    for (var i = 0; i < 5; ++i) {
      for (var angle in angles) {
        angle.update();
      }
      for (var constraint in constraints) {
        constraint.upate();
      }
    }

    for (var point in points) {
      point.collide(ball);
    }
  }

  void draw() {
    for (var shape in shapes) {
      shape.draw();
    }
  }
}

class HumanPoint {
  double x;
  double y;
  double px;
  double py;
  double vx;
  double vy;
  final double m;
  final double g;

  HumanPoint(
    double x,
    double y,
    StructPoint p,
    double s,
    this.g,
  )   : x = x + p.x * s,
        y = y + p.y * s,
        px = x + p.x * s,
        py = y + p.y * s,
        vx = 0.0,
        vy = 0.0,
        m = p.m ?? 1.0;

  void join(dynamic p1, double distance, double force) {
    var dx = p1.x - x;
    var dy = p1.y - y;
    var dist = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    var tw = m + p1.m;
    var r1 = p1.m / tw;
    var r0 = m / tw;
    var dz = (distance - dist) * force;
    var sx = dx / dist * dz;
    var sy = dy / dist * dz;
    p1.x += sx * r0;
    p1.y += sy * r0;
    x -= sx * r1;
    y -= sy * r1;
  }

  double dist(HumanPoint p1) {
    var dx = x - p1.x;
    var dy = y - p1.y;
    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
  }

  void integrate() {
    vx = x - px;
    vy = y - py;
    px = x;
    py = y;
    x += vx;
    y += vy + g;
  }

  void collide(CanvasTexture ball) {
    ball.x ??= 0;
    ball.y ??= 0;
    ball.radius ??= 0;
    var dx = x - ball.x;
    var dy = y - ball.y;
    var sd = math.pow(dx, 2) + math.pow(dy, 2);
    if (sd < math.pow(ball.radius, 2)) {
      var d = math.sqrt(sd);
      var dz = (ball.radius - d) * 0.5;
      x += dx / d * dz;
      y += dy / d * dz;
    }
  }
}

class HumanConstraint {
  final HumanPoint p0;
  final HumanPoint p1;
  final double distance;
  final double force;

  HumanConstraint(this.p0, this.p1, StructConstraint constraint)
      : distance = p0.dist(p1),
        force = constraint.force ?? 1.0;

  void upate() {
    p0.join(p1, distance, force);
  }
}

class HumanAngle {
  final HumanPoint p0;
  final HumanPoint p1;
  final HumanPoint p2;
  final double len1;
  final double len2;
  final double angle;
  final double range;
  final double force;
  final double m1;
  final double m2;
  final double m3;
  final double m4;

  HumanAngle(this.p0, this.p1, this.p2, StructAngle constraint)
      : len1 = p0.dist(p1),
        len2 = p1.dist(p2),
        angle = constraint.angle,
        range = constraint.range,
        force = constraint.force ?? 0.1,
        m1 = p0.m / (p0.m + p1.m),
        m2 = p1.m / (p0.m + p1.m),
        m3 = p1.m / (p1.m + p2.m),
        m4 = p2.m / (p1.m + p2.m);

  double a12(HumanPoint p0, HumanPoint p1, HumanPoint p2) {
    var a = math.atan2(p1.y - p0.y, p1.x - p0.x);
    var b = math.atan2(p2.y - p1.y, p2.x - p1.x);
    var c = angle - (b - a);
    var d = c > math.pi ? c - 2 * math.pi : c < -math.pi ? c + 2 * math.pi : c;
    var e = d.abs() > range ? (-d.sign * range + d) * force : 0;
    var cos = math.cos(a - e);
    var sin = math.sin(a - e);
    var x1 = p0.x + (p1.x - p0.x) * m2;
    var y1 = p0.y + (p1.y - p0.y) * m2;
    p0.x = x1 - cos * len1 * m2;
    p0.y = y1 - sin * len1 * m2;
    p1.x = x1 + cos * len1 * m1;
    p1.y = y1 + sin * len1 * m1;
    return e;
  }

  void a23(double e, HumanPoint p1, HumanPoint p2) {
    var a = math.atan2(p1.y - p2.y, p1.x - p2.x) + e;
    var cos = math.cos(a);
    var sin = math.sin(a);
    var x1 = p2.x + (p1.x - p2.x) * m3;
    var y1 = p2.y + (p1.y - p2.y) * m3;
    p2.x = x1 - cos * len2 * m3;
    p2.y = y1 - sin * len2 * m3;
    p1.x = x1 + cos * len2 * m4;
    p1.y = y1 + sin * len2 * m4;
  }

  void update() {
    // resolve angular constraints
    var e = a12(p0, p1, p2);
    a23(e, p1, p2);
  }
}

class HumanShape {
  final HumanPoint p0;
  final HumanPoint p1;
  final double width;
  final double height;
  final double offset;
  final Canvas canvas;
  CanvasTexture shape;

  HumanShape(
    this.p0,
    this.p1,
    StructConstraint shape,
    String src,
    double size,
    this.canvas,
  )   : width = shape.w * size,
        height = shape.h * size,
        offset = shape.offset {
    this.shape = canvas.createImage(
      shape.svg,
      'data:image/svg+xml;base64,${window.btoa(src)}',
      false,
    );
  }

  void draw() {
    canvas.drawImage(
      shape,
      p0.x,
      p0.y,
      w: height + width * offset,
      h: width,
      offsetX: -height * offset,
      offsetY: -width * 0.5,
      angle: math.atan2(p1.y - p0.y, p1.x - p0.x),
    );
  }
}
