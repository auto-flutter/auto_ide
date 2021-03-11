import 'package:flutter/material.dart';

class HoverListener extends StatefulWidget {
  final Widget Function(BuildContext context, bool value) builder;

  const HoverListener({Key key, @required this.builder}) : super(key: key);

  @override
  _HoverListenerState createState() => _HoverListenerState();
}

class _HoverListenerState extends State<HoverListener> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      child: widget.builder(context, hover),
    );
  }
}
