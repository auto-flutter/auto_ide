import 'package:auto_ide/src/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'draggable_proxy.dart';

class ReorderableWrap extends StatelessWidget {
  // final Axis direction;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final Clip clipBehavior;
  final List<Widget> children;
  final ReorderCallback onReorder;
  final EdgeInsetsGeometry itemPadding;
  final bool needLongPress;

  const ReorderableWrap({
    Key key,
    // this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.itemPadding,
    this.children = const <Widget>[],
    @required this.onReorder, this.needLongPress=false,
  }) : super(key: key);

  List<Widget> _buildChildren() {
    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(_Draggable(
          index: i,
          needLongPress: needLongPress,
          child: Container(
            padding: itemPadding,
            child: children[i],
          ),
          onReorder: onReorder));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<_IndexInfo>(
      onWillAccept: (_) {
        return true;
      },
      onAccept: (_IndexInfo info) {
        if (info.index == children.length - 1) {
          return;
        }
        onReorder(info.index, children.length);
      },
      builder: (_, __, ___) => Container(
        //Make sure to take up the remaining space
        alignment: Alignment.topLeft,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: alignment,
          runAlignment: runAlignment,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          clipBehavior: clipBehavior,
          children: _buildChildren(),
        ),
      ),
    );
  }
}

class _Draggable extends StatefulWidget {
  final Widget child;
  final int index;
  final ReorderCallback onReorder;
  final bool needLongPress;


  _Draggable({this.index, this.child, this.onReorder, this.needLongPress})
      : super(key: ValueKey(index));

  @override
  __DraggableState createState() => __DraggableState();
}

class _IndexInfo {
  final int index;
  final OutFunc<BuildContext> context;

  _IndexInfo(this.index, this.context);
}

class __DraggableState extends State<_Draggable> {
  double _draggableWidth = 0;

  @override
  Widget build(BuildContext context) {
    BuildContext feedbackContext;
    Widget child = DragTarget<_IndexInfo>(
      onWillAccept: (_IndexInfo info) {
        if (widget.index == info.index) {
          return false;
        }
        if (widget.index == info.index + 1) {
          _draggableWidth = 0;
        } else {
          _draggableWidth = info.context()?.size?.width ?? 0;
        }
        setState(() {});
        return true;
      },
      onAccept: (_IndexInfo info) {
        if (widget.index == info.index) {
          return;
        }
        setState(() {
          _draggableWidth = 0;
        });
        widget.onReorder(info.index, widget.index);
      },
      onLeave: (_) {
        setState(() {
          _draggableWidth = 0;
        });
      },
      builder: (_, __, ___) => Padding(
        padding: EdgeInsets.only(left: _draggableWidth),
        child: widget.child,
      ),
    );
    if(widget.needLongPress){
      return LongPressDraggable(
          child: child,
          childWhenDragging: SizedBox.shrink(),
          feedback: IgnorePointer(
              child: Builder(builder: (BuildContext context) {
                feedbackContext = context;
                return widget.child;
              })),
          data: _IndexInfo(widget.index, () => feedbackContext));

    }else{
      return DraggableProxy(
          child: child,
          childWhenDragging: SizedBox.shrink(),
          feedback: IgnorePointer(
              child: Builder(builder: (BuildContext context) {
                feedbackContext = context;
                return widget.child;
              })),
          data: _IndexInfo(widget.index, () => feedbackContext));
    }
  }
}
