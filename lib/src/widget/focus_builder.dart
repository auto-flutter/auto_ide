import 'package:flutter/material.dart';

class FocusBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, FocusNode node) builder;

  final bool skipTraversal;

  final bool canRequestFocus;

  const FocusBuilder(
      {Key key,
      @required this.builder,
      this.skipTraversal = false,
      this.canRequestFocus = true})
      : super(key: key);

  @override
  _FocusBuilderState createState() => _FocusBuilderState();
}

class _FocusBuilderState extends State<FocusBuilder> {
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(
        skipTraversal: widget.skipTraversal,
        canRequestFocus: widget.canRequestFocus);
  }

  @override
  void didUpdateWidget(covariant FocusBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (focusNode.skipTraversal != widget.skipTraversal) {
      focusNode.skipTraversal = widget.skipTraversal;
    }
    if (focusNode.canRequestFocus != widget.canRequestFocus) {
      focusNode.canRequestFocus = widget.canRequestFocus;
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, focusNode);
  }
}
