import 'point.dart';

class Link {
  final Point p0;
  final Point p1;
  final double length;

  Link(this.p0, this.p1) : length = p0.position.dist(p1.position);
}
