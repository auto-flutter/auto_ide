import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowsBar extends StatelessWidget {
  final Widget child;
  final Color color;

  const WindowsBar({Key key,@required this.child,@required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isWindows) {
      return child;
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: color),
          child: WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                      child: Container(color: color),
                      onDoubleTap: () {
                        appWindow.maximizeOrRestore();
                      },
                      onPanStart: (details) {
                        appWindow.startDragging();
                      },
                    )),
                MinimizeWindowButton(
                  colors: WindowButtonColors(
                      iconNormal: Color(0xd3FFFFFF),
                      mouseOver: Color(0xFF404040),
                      mouseDown: Color(0xFF202020),
                      iconMouseOver: Color(0xFFFFFFFF),
                      iconMouseDown: Color(0xFFF0F0F0)),
                ),
                MaximizeWindowButton(
                  colors: WindowButtonColors(
                      iconNormal: Color(0xd3FFFFFF),
                      mouseOver: Color(0xFF404040),
                      mouseDown: Color(0xFF202020),
                      iconMouseOver: Color(0xFFFFFFFF),
                      iconMouseDown: Color(0xFFF0F0F0)),
                ),
                CloseWindowButton(
                  colors: WindowButtonColors(
                      mouseOver: Color(0xFFD32F2F),
                      mouseDown: Color(0xFFB71C1C),
                      iconNormal: Color(0xd3FFFFFF),
                      iconMouseOver: Color(0xFFFFFFFF)),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: child)
      ],
    );
  }
}
