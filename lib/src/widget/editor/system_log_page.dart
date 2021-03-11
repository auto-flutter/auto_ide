import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:auto_ide/src/provider/system_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../log_view.dart';

class SystemLogPage extends StatefulWidget {
  @override
  _SystemLogPageState createState() => _SystemLogPageState();
}

class _SystemLogPageState extends State<SystemLogPage> {
  LogCollector _logCollector;
  final ScrollController scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final old = _logCollector;
    _logCollector = context.watch<LogCollector>();
    if (old != _logCollector) {
      _logCollector.addListener(_onAddLog);
      old?.removeListener(_onAddLog);
    }
  }

  void _onAddLog() {
    setState(() {});
    //todo scroll to last
  }

  @override
  void dispose() {
    super.dispose();
    _logCollector.removeListener(_onAddLog);
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<EditorStyle>();
    return Container(
      margin: EdgeInsets.all(32).copyWith(top: 16),
      padding: EdgeInsets.symmetric(horizontal: 32,vertical: 12),
      decoration: BoxDecoration(
          color: style.formColor, borderRadius: BorderRadius.circular(8)),
      child: LogView(
        logTotal: _logCollector.length,
        getLog: (int index) => _logCollector.get(index),
        scrollController: scrollController,
      ),
    );
  }
}

