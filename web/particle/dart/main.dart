import 'dart:html';

void main() {
  var iFrameElement = IFrameElement();
  iFrameElement.src = 'content.html';
  document.body.children.clear();
  document.body.children.add(iFrameElement);
}
