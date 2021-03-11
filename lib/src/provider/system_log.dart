import 'dart:async';

import 'package:auto_ide/src/common/common.dart';
import 'package:flutter/cupertino.dart';

class LogCollector extends ChangeNotifier {
  LogCollector(this.logStream, {int size = 2000}) : _list = CyclicList<String>(size) {
    _cancel = logStream.listen(_handleLog);
  }

  final Stream<String> logStream;
  final CyclicList<String> _list;

  StreamSubscription<String> _cancel;

  int get length => _list.length;

  String get(int index) {
    return _list[index];
  }

  void _handleLog(String log) {
    _list.add(log);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _cancel.cancel();
  }
}




