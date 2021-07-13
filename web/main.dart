import 'dart:html';

void main() {
  var outputElement = querySelector('#output');

  outputElement.children.clear();
  outputElement.children.add(
    buildButton(
      'HTML5 Canvas柳枝随风飘摇动画',
      'tree/',
      '#1d0d21',
    ),
  );

  outputElement.children.add(
    buildButton(
      'HTML5 Canvas人物四肢模拟及身体碰撞动画DEMO演示',
      'person/',
      '#EBAD00',
    ),
  );

  outputElement.children.add(
    buildButton(
      '基于Three.js和HTML5 Canvas的3D水晶球体',
      'crystal/',
      '#000000',
    ),
  );

  outputElement.children.add(
    buildButton(
      'HTML5 Canvas 3D绿色粒子动画DEMO演示',
      'particle/',
      '#000000',
    ),
  );
}

Element buildButton(String title, String path, String color) {
  var buttonElement = ButtonElement()
    ..text = title
    ..onClick.listen((event) {
      window.location.href = path;
    })
    ..animate(
      [
        {'opacity': 0},
        {'opacity': 100}
      ],
      200,
    );
  var style = buttonElement.style
    ..height = '30px'
    ..borderRadius = '4px'
    ..borderColor = '#1D0D21'
    ..outline = 'none'
    ..cursor = 'pointer'
    ..transitionDuration = '0.4s'
    ..margin = '10px'
    ..backgroundColor = color
    ..textAlign = 'center'
    ..textFillColor = 'green';
  buttonElement.onMouseEnter.listen((event) {
    style.backgroundColor = '#983454';
  });
  buttonElement.onMouseLeave.listen((event) {
    style.backgroundColor = color;
  });
  return DivElement()..children.add(buttonElement);
}
