import 'dart:convert';

import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/home_page.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:auto_ide/src/storage/kv_storage.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widget/windows_bar.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<String> history;

  @override
  void initState() {
    super.initState();
    final kv = context.read<KVStorage>();
    final historyJson = kv.get<String>('history', namespace: Namespace.welcome);
    if (historyJson != null) {
      final list = jsonDecode(historyJson) as List<dynamic>;
      history = list.cast<String>();
    } else {
      history = <String>[];
    }
  }

  Widget _buildButton(String path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: MaterialStateProperty.all(Color(0xff2D2D2D))),
          onPressed: () {
            _go(path);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      path,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    iconSize: 14,
                    constraints: BoxConstraints(),
                    splashRadius: 16,
                    icon: Icon(
                      Icons.close_sharp,
                    ),
                    onPressed: () {
                      setState(() {
                        history.remove(path);
                      });
                      _save();
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _save() {
    final kv = context.read<KVStorage>();
    kv.set('history', jsonEncode(history), namespace: Namespace.welcome);
  }

  void _go(String path) {
    history.remove(path);
    history.insert(0, path);
    _save();
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => HomePage(rootPath: path)));
  }

  @override
  Widget build(BuildContext context) {
    final WelcomeStyle style = context.read<WelcomeStyle>();
    return WindowsBar(
      color: style.color,
      child: Container(
        alignment: Alignment.center,
        color: style.color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    final rootPath = await getDirectoryPath();
                    if (rootPath == null) {
                      return;
                    }
                    _go(rootPath);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(style.buttonColor),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1))),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    child: Text(context.i18.open),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                constraints: BoxConstraints(maxWidth: 500),
                child: ListView(
                  children:
                      history.map((e) => _buildButton(e)).toList(growable: false),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
