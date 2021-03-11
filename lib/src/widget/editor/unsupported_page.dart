import 'package:flutter/material.dart';
import 'package:auto_ide/src/common/common.dart';

class UnsupportedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        context.i18.unsupportedPageTitle,
        style: Theme.of(context).textTheme.headline4.copyWith(color: Color(0xff989898)),
      ),
    );
  }
}
