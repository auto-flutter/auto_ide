import 'package:auto_ide/src/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LogView extends StatefulWidget {
  final InOutFunc<int, String> getLog;
  final int logTotal;
  final ScrollController scrollController;

  const LogView(
      {Key key,
      @required this.getLog,
      @required this.logTotal,
      this.scrollController})
      : super(key: key);

  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: widget.scrollController,
      isAlwaysShown: true,
      child: ListView.builder(
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: SelectableText(
              widget.getLog(index),
            ),
          );
        },
        itemCount: widget.logTotal,
        controller: widget.scrollController,
      ),
    );
  }
}
