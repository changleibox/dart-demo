import 'dart:html';
import 'dart:math' as math;

import 'package:dart_demo/tree/resource/colors.dart';
import 'package:dart_demo/tree/util/utils.dart';

import 'leaf.dart';
import 'link.dart';
import 'point.dart';
import 'vector.dart';
import 'wind.dart';

class Plant {
  Vector position;
  List<Point> points;
  List<Point> strands;
  List<Leaf> leaves;
  List<Link> links;
  double length;
  int resolution;
  double div;
  double minThickness;
  double maxThickness;
  double thickness;
  double zValue;
  List<String> colors;
  String trueColor;
  String color;

  Plant(double x, double y, double l, int height) {
    position = Vector(x, y);
    points = [];
    strands = [];
    leaves = [];
    links = [];
    length = l;
    resolution = map(length, 0, height, 3, 8).floor() + random(0, 2).round();
    div = length / resolution;
    minThickness = 10;
    maxThickness = 32;
    thickness = map(length, height, 0, minThickness, maxThickness) * random(0.8, 1.2);
    zValue = 0;
    colors = ['#4a2525', '#562a3b'];
    trueColor = colors[(math.Random().nextDouble() * colors.length).floor()];
  }

  set setZValue(double zValue) {
    this.zValue = zValue;
    color = lerpColor(trueColor, backgroundColor, zValue);
  }

  void init() {
    for (var i = 0; i < resolution; i++) {
      var x = position.x;
      var y = position.y + i * div;
      strands.add(Point(x, y));
    }
    strands[0].pinned = true;
    for (var i = 0; i < resolution - 1; i++) {
      links.add(Link(strands[i], strands[i + 1]));
    }

    for (var i = 1; i < resolution; i++) {
      var leafSize = map(thickness, minThickness, maxThickness, 10, 60);
      leafSize *= map(i, 0, resolution, 1.2, 0.8);

      var leafLeft = Leaf(strands[i], leafSize);
      leafLeft.end.angle = math.pi + random(-0.2, 0.2);
      leafLeft.setZValue(zValue);
      leaves.add(leafLeft);
      links.add(Link(leafLeft.parent, leafLeft.end));

      var leafRight = Leaf(strands[i], leafSize);
      leafRight.end.angle = 0 + random(-0.2, 0.2);
      leafRight.setZValue(zValue);
      leaves.add(leafRight);
      links.add(Link(leafRight.parent, leafRight.end));
    }

    points.addAll(leaves.map((e) => e.end));
    points.addAll(strands);
  }

  void translate(double x, double y) {
    position.setValue(x, y);
    strands[0].position.setValue(x, y);
  }

  void render(CanvasRenderingContext2D context) {
    context.strokeStyle = color;
    context.lineWidth = thickness;
    context.beginPath();
    context.moveTo(strands[0].position.x, strands[0].position.y);
    for (var i = 2; i < strands.length; i++) {
      context.lineTo(strands[i - 1].position.x, strands[i - 1].position.y);
      context.lineTo(strands[i].position.x, strands[i].position.y);
    }
    context.stroke();
    leaves.forEach((element) {
      element.render(context);
    });
  }

  void update(int height, Wind wind, Vector gravity, Vector mouse) {
    for (var i = 0; i < points.length; i++) {
      var point = points[i];

      if (point.pinned) {
        continue;
      }
      var velocity = point.position.copy();
      velocity.sub(point.oldPosition);
      velocity.mult(0.98);
      point.oldPosition = point.position.copy();
      point.position.add(velocity);
      if (point.angle != null) {
        point.position.x += math.cos(point.angle) * 1;
        point.position.y += math.sin(point.angle) * 1;
      }
      var internalWind = wind.value.copy();
      internalWind.mult(zValue + 0.1);
      point.position.add(internalWind);
      point.position.add(gravity);

      var distance = point.position.dist(mouse);

      if (distance < 200) {
        var force = Vector(0, 0);
        force.mag = map(distance, 0, 200, 2, 0) * (-zValue + 1);
        force.heading = point.position.angle(mouse);
        point.position.sub(force);
      }

      if (point.position.y > height) {
        point.position.y = height.toDouble();
        point.position.y = point.position.y + velocity.y * 0.2;
      }
    }

    for (var i = 0; i < 4; i++) {
      links.forEach((element) {
        var distance = element.p0.position.dist(element.p1.position);
        var difference = element.length - distance;
        var percent = difference / distance / 2;
        var offset = Vector(
          (element.p1.position.x - element.p0.position.x) * percent,
          (element.p1.position.y - element.p0.position.y) * percent,
        );
        if (!element.p0.pinned && element.p1.angle == null) {
          element.p0.position.sub(offset);
        }
        if (!element.p1.pinned && element.p0.angle == null) {
          element.p1.position.add(offset);
        }
      });
    }
  }
}
