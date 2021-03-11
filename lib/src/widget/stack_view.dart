import 'dart:math';

import 'package:auto_ide/src/common/listenable.dart';
import 'package:flutter/material.dart';

import '../common/view_key.dart';

abstract class StackViewListener {
  void onOpen(ViewKey key, WidgetBuilder createIfAbsent);

  void onClose(ViewKey key);
}

class StackController with GenericListenable<StackViewListener> {
  void open(ViewKey key, WidgetBuilder createIfAbsent) {
    foreach((entry) {
      entry.onOpen(key, createIfAbsent);
    });
  }

  void close(ViewKey key) {
    foreach((entry) {
      entry.onClose(key);
    });
  }
}

class StackView extends StatefulWidget {
  final StackController controller;
  final ValueChanged<ViewKey> onCurrentIndexChanged;

  const StackView({Key key, this.controller, this.onCurrentIndexChanged}) : super(key: key);

  @override
  _StackViewState createState() => _StackViewState();
}

class _StackViewState extends State<StackView> implements StackViewListener {
  int _currentIndex = 0;
  List<ViewKeyWidget> _list = <ViewKeyWidget>[];

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
  void didUpdateWidget(covariant StackView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(this);
      widget.controller?.addListener(this);
    }
  }

  @override
  void onOpen(ViewKey key, WidgetBuilder createIfAbsent) {
    _open(key, createIfAbsent);
  }

  @override
  void onClose(ViewKey key) {
    _close(key);
  }

  void _open(ViewKey key, WidgetBuilder createIfAbsent) {
    int index = _list.indexWhere((element) => element.key == key);
    if (index == _currentIndex) {
      return;
    }

    if (index == -1) {
      _currentIndex = _list.length;
      _list.add(ViewKeyWidget(key: key, child: createIfAbsent(context)));
    } else {
      _currentIndex = index;
    }
    widget.onCurrentIndexChanged?.call(_list[_currentIndex].key);
    _markNeedUpdate();
  }

  void _close(ViewKey key) {
    int index = _list.indexWhere((element) => element.key == key);
    if (index == -1) {
      return;
    }
    _list.removeAt(index);
    if (index <= _currentIndex) {
      _currentIndex--;
      _currentIndex = max(0, _currentIndex);
      if(_list.isEmpty){
        widget.onCurrentIndexChanged?.call(null);
      }else{
        widget.onCurrentIndexChanged?.call(_list[_currentIndex].key);
      }
    }
    _markNeedUpdate();
  }

  void _markNeedUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: _list,
    );
  }
}
