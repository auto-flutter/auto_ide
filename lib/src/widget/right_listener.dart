import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RightClickListener extends StatelessWidget {
  final void Function(Offset position) onRightClick;

  final Widget child;

  const RightClickListener({Key key, this.onRightClick, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (event) {
          if (event.kind == PointerDeviceKind.mouse &&
              event.buttons == kSecondaryMouseButton) {
            onRightClick?.call(event.position);
          }
        },
        child: child);
  }
}
