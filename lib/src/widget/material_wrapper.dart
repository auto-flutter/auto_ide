
import 'package:flutter/material.dart';

///see: https://github.com/flutter/flutter/issues/3782
class MaterialWrapper extends StatelessWidget {

  final Widget child;

  const MaterialWrapper({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child:child
    );
  }
}
