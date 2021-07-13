import 'dart:math' as math;

double linear(currentTime, start, degreeOfChange, duration) => degreeOfChange * currentTime / duration + start;

double easeInOutQuad(t, b, c, d) {
  t /= d / 2;
  if (t < 1) {
    return c / 2 * math.pow(t, 2) + b;
  }
  t--;
  return -c / 2 * (t * (t - 2) - 1) + b;
}

double easeInOutExpo(t, b, c, d) {
  t /= d / 2;
  if (t < 1) {
    return c / 2 * math.pow(2, 10 * (t - 1)) + b;
  }
  t--;
  return c / 2 * (-math.pow(2, -10 * t) + 2) + b;
}
