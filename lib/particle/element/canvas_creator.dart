import 'dart:html';

import 'package:dart_demo/creator/creator.dart';

class CanvasCreator extends Creator {
  final CanvasElement _canvasElement;

  CanvasCreator() : _canvasElement = CanvasElement();

  @override
  void build(Element element) {
    element.children.clear();
    element.children.add(_canvasElement);
  }
}
