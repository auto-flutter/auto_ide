import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:auto_ide/src/widget/stack_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../reorderable_wrap.dart';
import '../right_listener.dart';
import '../right_menu.dart';

abstract class EditorListener {
  void onOpen(
      {@required ViewKey key,
      @required String tab,
      @required WidgetBuilder contentIfAbsent,
      VoidCallback onTapTab});

  void onClose(ViewKey key);
}

class EditorController with GenericListenable<EditorListener> {
  void open(
      {@required ViewKey key,
      @required String tab,
      @required WidgetBuilder contentIfAbsent,
      VoidCallback onTapTab}) {
    foreach((entry) {
      entry.onOpen(
          key: key,
          contentIfAbsent: contentIfAbsent,
          tab: tab,
          onTapTab: onTapTab);
    });
  }

  void close(ViewKey key) {
    foreach((entry) {
      entry.onClose(key);
    });
  }
}

class _TabPage {
  final String tab;
  final WidgetBuilder builder;
  final ViewKey key;
  final VoidCallback onTapTab;

  _TabPage(
      {@required this.tab,
      @required this.builder,
      @required this.key,
      this.onTapTab});
}

class Editor extends StatefulWidget {
  final EditorController controller;

  const Editor({Key key, this.controller}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> implements EditorListener {
  final StackController controller = StackController();
  List<_TabPage> _tabs = <_TabPage>[];
  _TabPage current;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(this);
  }

  @override
  void didUpdateWidget(covariant Editor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(this);
      widget.controller?.addListener(this);
    }
  }

  @override
  void onClose(ViewKey key) {
    _close(key);
  }

  @override
  void onOpen(
      {@required ViewKey key,
      @required String tab,
      @required WidgetBuilder contentIfAbsent,
      VoidCallback onTapTab}) {
    _open(
        key: key,
        tab: tab,
        contentIfAbsent: contentIfAbsent,
        onTapTab: onTapTab);
  }

  void _open(
      {@required ViewKey key,
      @required String tab,
      @required WidgetBuilder contentIfAbsent,
      VoidCallback onTapTab}) {
    if (_tabs.any((element) => element.key == key)) {
      if (current.key != key) {
        controller.open(key, contentIfAbsent);
      }
    } else {
      _tabs.add(_TabPage(
          tab: tab, builder: contentIfAbsent, key: key, onTapTab: onTapTab));
      controller.open(key, contentIfAbsent);
    }
    setState(() {});
  }

  void _close(ViewKey key) {
    int index = _tabs.indexWhere((element) => element.key == key);
    if (index == -1) {
      return;
    }
    controller.close(key);
    _tabs.removeAt(index);
    setState(() {});
  }

  void _onCurrentIndexChanged(ViewKey key) {
    if (key == null) {
      current = null;
    } else {
      current =
          _tabs.firstWhere((element) => element.key == key, orElse: () => null);
      assert(current != null);
    }

    setState(() {});
  }

  void _handleRightClick(_TabPage page, Offset position) {
    showRightMenu([
      MenuGroup(items: [
        MenuItem(
            text: context.i18.editorTabClose,
            onTap: () {
              _close(page.key);
            }),
        MenuItem(
            text: context.i18.editorTabCloseOther,
            onTap: () {
              _tabs.toList(growable: false).forEach((element) {
                if (element.key != page.key) {
                  _close(element.key);
                }
              });
            }),
        MenuItem(
            text: context.i18.editorTabCloseAll,
            onTap: () {
              _tabs.toList(growable: false).forEach((element) {
                _close(element.key);
              });
            }),
        MenuItem(
            text: context.i18.editorTabCloseLeft,
            onTap: () {
              int index =
                  _tabs.indexWhere((element) => element.key == page.key);
              _tabs.sublist(0, index).forEach((element) {
                _close(element.key);
              });
            }),
        MenuItem(
            text: context.i18.editorTabCloseRight,
            onTap: () {
              int index =
                  _tabs.indexWhere((element) => element.key == page.key);
              _tabs.sublist(index + 1).forEach((element) {
                _close(element.key);
              });
            }),
      ]),
    ], padding: EdgeInsets.only(right: 48), target: position);
  }

  void onReorder(int oldIndex, int newIndex) {
    if ((oldIndex - newIndex).abs() == 1) {
      final old = _tabs[oldIndex];
      _tabs[oldIndex] = _tabs[newIndex];
      _tabs[newIndex] = old;
    } else {
      final item = _tabs.removeAt(oldIndex);
      if (oldIndex < newIndex) {
        newIndex--;
      }
      _tabs.insert(newIndex, item);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    EditorStyle style = context.watch<EditorStyle>();
    return Container(
      alignment: Alignment.topLeft,
      color: style.color,
      padding: EdgeInsets.only(top: 12),
      child: Column(
        children: [
          if (_tabs.isNotEmpty)
            Container(
              padding: EdgeInsets.only(left: 8),
              alignment: Alignment.topLeft,
              child: ReorderableWrap(
                  onReorder: onReorder,
                  // needLongPress: true,
                  alignment: WrapAlignment.start,
                  itemPadding: EdgeInsets.only(right: 8, bottom: 6),
                  children: _tabs.map((e) => _buildButton(e, style)).toList()),
            ),
          if (_tabs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Divider(
                height: 2,
                thickness: 5,
                color: style.dividerColor,
              ),
            ),
          Expanded(
              child: StackView(
            controller: controller,
            onCurrentIndexChanged: _onCurrentIndexChanged,
          ))
        ],
      ),
    );
  }

  Widget _buildButton(_TabPage page, EditorStyle style) {
    return Container(
      key: ValueKey(page),
      child: RightClickListener(
        onRightClick: (offset) {
          _handleRightClick(page, offset);
        },
        child: ElevatedButton(
            style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: MaterialStateProperty.all(
                    current == page ? style.tabActiveColor : style.tabColor)),
            onPressed: () {
              _open(
                  key: page.key,
                  tab: page.tab,
                  contentIfAbsent: page.builder,
                  onTapTab: page.onTapTab);
              page.onTapTab?.call();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(page.tab),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: style.tabCloseIconSize,
                      constraints: BoxConstraints(),
                      splashRadius: 16,
                      icon: Icon(
                        Icons.close_sharp,
                      ),
                      onPressed: () {
                        _close(page.key);
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
