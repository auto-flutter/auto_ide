import 'dart:io';

import 'package:auto_ide/main.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:auto_ide/src/widget/material_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'common/common.dart';
import 'widget/editor/editor.dart';
import 'widget/reorderable_wrap.dart';
import 'widget/tool/application_manager.dart';
import 'widget/tool/tool.dart';
import 'widget/tool/file_manager.dart';
import 'widget/windows_bar.dart';

class HomePage extends StatefulWidget {
  final String rootPath;

  const HomePage({Key key, @required this.rootPath}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EditorController controller = EditorController();
  final FileManagerController fileController = FileManagerController();
  final ApplicationManagerController applicationManagerController =
      ApplicationManagerController();
  final ToolController toolController = ToolController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      toolController.toggleTool(viewKey: ConstViewKey.fileManager);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<EditorStyle>();
    return MultiProvider(
      providers: [
        Provider.value(value: controller),
        Provider.value(value: fileController),
        Provider.value(value: applicationManagerController),
        Provider.value(value: toolController),
      ],
      child: Scaffold(
        body: Row(
          children: [
            Tool(
              workDir: widget.rootPath,
            ),
            Expanded(
                child: WindowsBar(
                    color: style.color, child: Editor(controller: controller)))
          ],
        ),
      ),
    );
  }
}

class EditWindow extends StatefulWidget {
  @override
  _EditWindowState createState() => _EditWindowState();
}

class _EditWindowState extends State<EditWindow> {
  List<int> _list;

  @override
  void initState() {
    super.initState();
    _list = List.generate(20, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialWrapper(
      child: Container(
        alignment: Alignment.topLeft,
        color: Color(0xff1E1E1E),
        padding: EdgeInsets.only(top: 12),
        child: Column(
          children: [
            if (_list.isNotEmpty)
              Container(
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.topLeft,
                child: ReorderableWrap(
                    onReorder: (int oldIndex, int newIndex) {
                      if ((oldIndex - newIndex).abs() == 1) {
                        final old = _list[oldIndex];
                        _list[oldIndex] = _list[newIndex];
                        _list[newIndex] = old;
                        setState(() {});
                        return;
                      }
                      final item = _list.removeAt(oldIndex);
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }
                      _list.insert(newIndex, item);

                      setState(() {});
                    },
                    alignment: WrapAlignment.start,
                    itemPadding: EdgeInsets.only(right: 8, bottom: 8),
                    children: _list.map((e) => buildButton(e)).toList()),
              ),
            if (_list.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Divider(
                  height: 2,
                  thickness: 5,
                  color: Color(0xff262525),
                ),
              ),
            Expanded(
              child: Column(
                children: [],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(int value) {
    return Container(
      key: ValueKey(value),
      // padding: EdgeInsets.only(right: 12),
      child: ElevatedButton(
          style: ButtonStyle(
              // shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: MaterialStateProperty.all(
                  value == 1 ? Colors.blue[800] : Color(0xff2D2D2D))),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(1.0).copyWith(left: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'item  ${value == 1 ? 'tttttttttttttttt' : value.toString()}'),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  // padding: EdgeInsets.zero,
                  iconSize: 14,
                  constraints: BoxConstraints(),
                  splashRadius: 24,
                  icon: Icon(
                    Icons.close_sharp,
                    // size: 14,
                  ),
                  onPressed: () {
                    _list.removeWhere((element) => element == value);
                    setState(() {});
                  },
                ),
              ],
            ),
          )),
    );
  }
}
