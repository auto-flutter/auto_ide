import 'package:auto_ide/src/common/common.dart';
import 'package:flutter/material.dart';

class ProxyInitState extends StatefulWidget {
  final Widget child;
  final InFunc<BuildContext> initStateCallback;

  const ProxyInitState({Key key,@required  this.initStateCallback,@required this.child})
      : super(key: key);

  @override
  _ProxyInitStateState createState() => _ProxyInitStateState();
}

class _ProxyInitStateState extends State<ProxyInitState> {
  @override
  void initState() {
    super.initState();
    widget.initStateCallback(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}