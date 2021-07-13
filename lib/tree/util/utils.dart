import 'dart:html';
import 'dart:math' as math;

double get timestamp => window.performance.now();

double random(min, max) => min + math.Random().nextDouble() * (max - min);

double map(a, b, c, d, e) => (a - b) / (c - b) * (e - d) + d;

double lerp(value1, value2, amount) => value1 + (value2 - value1) * amount;

double clamp(value, min, max) => math.max(min, math.min(max, value));

String lerpColor(a, b, amount) {
  var ah = int.tryParse(a.replaceAll('#', ''), radix: 16);
  var ar = ah >> 16;
  var ag = (ah >> 8) & 0xff;
  var ab = ah & 0xff;
  var bh = int.tryParse(b.replaceAll('#', ''), radix: 16);
  var br = bh >> 16;
  var bg = (bh >> 8) & 0xff;
  var bb = bh & 0xff;
  var rr = ar + amount * (br - ar);
  var rg = ag + amount * (bg - ag);
  var rb = ab + amount * (bb - ab);
  return '#${(((1 << 24) + (rr.round() << 16) + (rg.round() << 8) + rb).round() | 0).toRadixString(16).substring(1)}';
}
