import 'dart:math';

import 'package:auto_core/auto_core.dart';
import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/provider/style.dart';
import 'package:auto_ide/src/widget/measure_size.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CheckpointEditor extends StatefulWidget {
  final List<Checkpoint> checkpoints;

  final bool Function(String name, RatioRect ratioRect) onAddMatchPosition;
  final bool Function(String name, RatioRect ratioRect) onRemoveMatchPosition;

  const CheckpointEditor(
      {Key key,
      @required this.checkpoints,
      @required this.onAddMatchPosition,
      @required this.onRemoveMatchPosition})
      : super(key: key);

  @override
  _CheckpointEditorState createState() => _CheckpointEditorState();
}

class _CheckpointEditorState extends State<CheckpointEditor> {
  Checkpoint current;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.checkpoints.isNotEmpty) {
      current = widget.checkpoints.first;
    }
  }

  @override
  void didUpdateWidget(CheckpointEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checkpoints != widget.checkpoints) {
      if (widget.checkpoints.isNotEmpty) {
        current = widget.checkpoints.first;
      } else {
        current = null;
      }
    }
  }

  Widget buildImageListView(EditorStyle style) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: style.formSecondaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: ListView.builder(
            controller: scrollController,
            itemBuilder: (_, index) {
              final checkPoint = widget.checkpoints[index];
              return Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      current = checkPoint;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          width: 3,
                          color: checkPoint == current
                              ? style.activeBorderColor
                              : style.formSecondaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.memory(
                        checkPoint.snapshot,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: widget.checkpoints.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checkpoints.isEmpty) {
      return SizedBox.shrink();
    }
    assert(current != null);
    final style = context.read<EditorStyle>();
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: style.formColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: _ImageEditor(
              value: current,
              onAddMatchPosition: widget.onAddMatchPosition,
              onRemoveMatchPosition: widget.onRemoveMatchPosition,
            )),
            buildImageListView(style),
          ],
        ),
      ),
    );
  }
}

class _EditRecord {
  final bool isAdd;
  final RatioRect ratioRect;

  _EditRecord({@required this.isAdd, @required this.ratioRect});
}

class _ImageEditor extends StatefulWidget {
  final Checkpoint value;

  final bool Function(String name, RatioRect ratioRect) onAddMatchPosition;

  final bool Function(String name, RatioRect ratioRect) onRemoveMatchPosition;

  const _ImageEditor(
      {Key key,
      @required this.value,
      @required this.onAddMatchPosition,
      @required this.onRemoveMatchPosition})
      : super(key: key);

  @override
  __ImageEditorState createState() => __ImageEditorState();
}

class __ImageEditorState extends State<_ImageEditor> {
  Rect imageRect;
  Offset startOffset;
  Rect _rect;
  RatioRect selectRatioRect;
  List<_EditRecord> redoHistory = <_EditRecord>[];
  List<_EditRecord> undoHistory = <_EditRecord>[];
  double zoom = 0;
  double scale = 1;
  final ScrollController editScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    imageRect = Rect.zero;
  }

  @override
  void didUpdateWidget(covariant _ImageEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      selectRatioRect = null;
      redoHistory.clear();
      undoHistory.clear();
    }
  }

  void _delete() {
    assert(selectRatioRect != null);
    widget.onRemoveMatchPosition(widget.value.name, selectRatioRect);
  }

  void _redo() {
    assert(redoHistory.isNotEmpty);
    final item = redoHistory.removeLast();
    bool result;
    if (item.isAdd) {
      result = widget.onAddMatchPosition(widget.value.name, item.ratioRect);
    } else {
      result = widget.onRemoveMatchPosition(widget.value.name, item.ratioRect);
    }
    if (result) {
      setState(() {
        undoHistory.add(item);
      });
    }
  }

  void _undo() {
    assert(undoHistory.isNotEmpty);
    final item = undoHistory.removeLast();
    bool result;
    if (item.isAdd) {
      result = widget.onRemoveMatchPosition(widget.value.name, item.ratioRect);
    } else {
      result = widget.onAddMatchPosition(widget.value.name, item.ratioRect);
    }
    if (result) {
      setState(() {
        redoHistory.add(item);
      });
    }
  }

  void _zoomReset() {
    setState(() {
      zoom = 0;
      scale=1;
    });
  }

  void _zoomIn() {
    setState(() {
      zoom += 100;
      scale-=0.1;
      scale=max(scale, 0.1);
    });
  }

  void _zoomOut() {
    setState(() {
      zoom -= 100;
      scale+=0.1;
    });
  }

  Widget buildDeleteButton() {
    VoidCallback onPressed;
    if (selectRatioRect != null &&
        widget.value.matchPositions.contains(selectRatioRect)) {
      onPressed = _delete;
    }

    return IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.close),
      color: Colors.lightBlue,
      tooltip: context.i18.delete,
      iconSize: 18,
      splashRadius: 24,
    );
  }

  Widget buildRedoButton() {
    VoidCallback onPressed;
    if (redoHistory.isNotEmpty) {
      onPressed = _redo;
    }

    return IconButton(
      tooltip: context.i18.redo,
      color: Colors.lightBlue,
      icon: Icon(Icons.redo),
      iconSize: 18,
      splashRadius: 24,
      onPressed: onPressed,
    );
  }

  Widget buildUndoButton() {
    VoidCallback onPressed;
    if (undoHistory.isNotEmpty) {
      onPressed = _undo;
    }

    return IconButton(
      tooltip: context.i18.undo,
      color: Colors.lightBlue,
      icon: Icon(Icons.undo),
      iconSize: 18,
      splashRadius: 24,
      onPressed: onPressed,
    );
  }

  Widget buildZoomOutButton() {
    VoidCallback onPressed;
    if (zoom != 0) {
      onPressed = _zoomOut;
    }

    return IconButton(
      tooltip: context.i18.zoomOut,
      color: Colors.lightBlue,
      icon: Icon(Icons.zoom_out_rounded),
      iconSize: 18,
      splashRadius: 24,
      onPressed: onPressed,
    );
  }

  Widget buildZoomInButton() {
    return IconButton(
      tooltip: context.i18.zoomIn,
      color: Colors.lightBlue,
      icon: Icon(Icons.zoom_in_rounded),
      iconSize: 18,
      splashRadius: 24,
      onPressed: _zoomIn,
    );
  }

  Widget buildZoomResetButton() {
    return IconButton(
      tooltip: context.i18.zoomReset,
      color: Colors.lightBlue,
      icon: Icon(Icons.youtube_searched_for_outlined),
      iconSize: 18,
      splashRadius: 24,
      onPressed: zoom!=0?_zoomReset:null,
    );
  }

  Widget buildToolBar() {
    final style = context.watch<EditorStyle>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: style.formSecondaryColor,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Wrap(
            children: [
              buildDeleteButton(),
              buildRedoButton(),
              buildUndoButton(),
              buildZoomOutButton(),
              buildZoomInButton(),
              buildZoomResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildMatchPoints() {
    if (imageRect == Rect.zero) {
      return [];
    }

    return widget.value.matchPositions.map((rect) {
      return buildMatchPointItem(rect);
    }).toList();
  }

  Widget buildMatchPointItem(RatioRect ratioRect) {
    final rect =RatioRectHelper.transform(imageRect, ratioRect);
    return Positioned.fromRect(
        rect: rect,
        child: InkWell(
          onTap: () {
            setState(() {
              if (selectRatioRect == ratioRect) {
                selectRatioRect = null;
              } else {
                selectRatioRect = ratioRect;
              }
            });
          },
          child: Container(
            height: rect.height,
            width: rect.width,
            decoration: BoxDecoration(
                color: selectRatioRect == ratioRect
                    ? Colors.blue.withAlpha(120)
                    : null,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(width: 1.5, color: Colors.redAccent)),
          ),
        ));
  }

  Widget buildEditItem(Rect rect) {
    return Positioned.fromRect(
        rect: rect,
        child: Container(
          height: rect.height,
          width: rect.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(width: 1.5, color: Colors.redAccent)),
        ));
  }

  Widget buildEditor() {
    final style = context.watch<EditorStyle>();
    return LayoutBuilder(
      builder: (_, c) => Scrollbar(
        controller: editScrollController,
        isAlwaysShown: zoom > 0,
        child: SingleChildScrollView(
          controller: editScrollController,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: c.maxHeight + zoom,maxWidth: c.maxWidth+zoom),
              child: Stack(
                children: [
                  GestureDetector(
                    onPanStart: (DragStartDetails data) {
                      setState(() {
                        startOffset = data.localPosition;
                        _rect = Rect.fromPoints(startOffset, startOffset);
                      });
                    },
                    onPanUpdate: (DragUpdateDetails data) {
                      setState(() {
                        final offset = Offset(
                            data.localPosition.dx.clamp(0.0, imageRect.width),
                            data.localPosition.dy.clamp(0.0, imageRect.height));
                        _rect = Rect.fromPoints(startOffset, offset);
                      });
                    },
                    onPanEnd: (_) async {
                      final ratioRect = RatioRectHelper.resolve(imageRect, _rect);
                      if (ratioRect.leftRatio == ratioRect.rightRatio &&
                          ratioRect.topRatio == ratioRect.bottomRatio) {
                        return;
                      }
                      final result = widget.onAddMatchPosition(
                          widget.value.name, ratioRect);
                      setState(() {
                        _rect = null;
                        if (result) {
                          undoHistory.add(
                              _EditRecord(isAdd: true, ratioRect: ratioRect));
                        }
                      });
                    },
                    child: MeasureSize(
                      onChange: (Size arg) {
                        setState(() {
                          imageRect =
                              Rect.fromLTWH(0, 0, arg.width, arg.height);
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          color: style.formSecondaryColor,
                          child: Image.memory(
                            widget.value.snapshot,
                            scale: scale,
                            gaplessPlayback: true,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...buildMatchPoints(),
                  if (_rect != null) buildEditItem(_rect)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [buildToolBar(), Expanded(child: buildEditor())],
    );
  }
}
