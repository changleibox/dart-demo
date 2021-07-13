import 'dart:html';

import 'package:dart_demo/tree/element/canvas_creator.dart';

void main() {
  var outputElement = querySelector('#output');

  var creator = CanvasCreator();
  creator.build(outputElement);
}
