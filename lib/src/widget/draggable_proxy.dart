import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

///class DraggableProxy will ignore mouse right-click
class DraggableProxy<T> extends Draggable<T> {
  DraggableProxy({
    Widget child,
    Widget feedback,
    Widget childWhenDragging,
    T data,
  }) : super(child: child, feedback: feedback, data: data,childWhenDragging: childWhenDragging);

  @override
  MultiDragGestureRecognizer<MultiDragPointerState> createRecognizer(
      GestureMultiDragStartCallback onStart) {
    return _ImmediateMultiDragGestureRecognizer()..onStart = onStart;
  }
}

class _ImmediateMultiDragGestureRecognizer
    extends ImmediateMultiDragGestureRecognizer {
  @override
  bool isPointerAllowed(PointerDownEvent event) {
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      return false;
    }
    return super.isPointerAllowed(event);
  }
}
