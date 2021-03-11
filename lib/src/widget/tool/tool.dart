import 'dart:math';

import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/common/namespace.dart';
import 'package:auto_ide/src/common/view_key.dart';
import 'package:auto_ide/src/common/context_helper.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:auto_ide/src/widget/editor/editor.dart';
import 'package:auto_ide/src/widget/editor/settings_page.dart';
import 'package:auto_ide/src/widget/editor/system_log_page.dart';
import 'package:auto_ide/src/widget/tool/application_manager.dart';
import 'package:auto_ide/src/widget/tool/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../hover_listener.dart';
import '../material_wrapper.dart';
import '../stack_view.dart';

abstract class ToolListener {
  void onToggleTool({@required ViewKey viewKey});
}

class ToolController with GenericListenable<ToolListener> {
  void toggleTool({@required ViewKey viewKey}) {
    foreach((entry) {
      entry.onToggleTool(viewKey: viewKey);
    });
  }
}

class Tool extends StatefulWidget {
  final String workDir;

  Tool({@required this.workDir}) : super(key: ValueKey(workDir));

  @override
  _ToolState createState() => _ToolState();
}

class _ToolState extends State<Tool> implements ToolListener {
  bool windowOffstage = true;
  final StackController controller = StackController();
  ViewKey current;

  ToolController toolController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ToolController old = toolController;
    toolController = context.watch<ToolController>();
    if (old != toolController) {
      toolController.addListener(this);
      old?.removeListener(this);
    }
  }

  @override
  void dispose() {
    toolController?.removeListener(this);
    super.dispose();
  }

  @override
  void onToggleTool({@required ViewKey viewKey}) {
    if (current == viewKey) {
      setState(() {
        windowOffstage = !windowOffstage;
      });
    } else {
      setState(() {
        windowOffstage = false;
        current = viewKey;
      });
      if (viewKey == ConstViewKey.fileManager) {
        controller.open(ConstViewKey.fileManager,
            (context) => FileManager(rootPath: widget.workDir));
      } else if (viewKey == ConstViewKey.applicationManager) {
        controller.open(
            ConstViewKey.applicationManager, (context) => ApplicationManager());
      } else {
        throw Exception('Unknown viewKey');
      }
    }
  }

  void _handleTapFileManager() {
    onToggleTool(viewKey: ConstViewKey.fileManager);
  }

  void _handleTapDeviceManager() {
    onToggleTool(viewKey: ConstViewKey.applicationManager);
  }

  void _handleTapSetting() {
    final editor = context.read<EditorController>();
    editor.open(
        key: ConstViewKey.settings,
        tab: context.i18.settingsTab,
        contentIfAbsent: (_) => SettingsPage(
              viewKey: ConstViewKey.settings,
            ));
  }

  void _handleTapSystemLog() {
    final editor = context.read<EditorController>();
    editor.open(
        key: ConstViewKey.systemLog,
        tab: context.i18.systemLogTab,
        contentIfAbsent: (_) => SystemLogPage());
  }

  Widget _buildToolbar() {
    return Selector<IdeStyle, ToolBarStyle>(
      selector: (_, style) => style.toolBarStyle,
      builder: (_, style, ___) => Container(
        color: style.color,
        width: style.width,
        child: MaterialWrapper(
          child: Column(
            children: [
              _buildIconButton(
                  _handleTapFileManager,
                  Icons.insert_drive_file_outlined,
                  context.i18.toolbarFileManagerTip),
              _buildIconButton(_handleTapDeviceManager, Icons.devices,
                  context.i18.toolbarApplicationManagerTip),
              _buildIconButton(
                  _handleTapSystemLog,
                  CupertinoIcons.square_stack_3d_up,
                  context.i18.toolbarSystemLogTip),
              _buildIconButton(_handleTapSetting, Icons.settings,
                  context.i18.toolbarSettingsTip),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(VoidCallback onPressed, IconData icon, String tip) {
    return Tooltip(
      message: tip,
      child: HoverListener(
        builder: (_, hover) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: hover ? Colors.white : Colors.grey[500]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildToolbar(),
        Offstage(
            offstage: windowOffstage,
            child: _ToolWindow(
              controller: controller,
            ))
      ],
    );
  }
}

class _ToolWindow extends StatefulWidget {
  final StackController controller;

  const _ToolWindow({Key key, this.controller}) : super(key: key);

  @override
  _ToolWindowState createState() => _ToolWindowState();
}

class _ToolWindowState extends State<_ToolWindow> {
  double width;
  double prevWidth;
  Offset origin;

  @override
  void initState() {
    super.initState();
    width = context.read<IdeStyle>().toolWindowStyle.width;
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<ToolViewStyle>();
    return Container(
        width: width,
        color: style.color,
        child: Row(
          children: [
            Expanded(child: StackView(controller: widget.controller)),
            MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: GestureDetector(
                onHorizontalDragStart: (event) {
                  origin = event.globalPosition;
                  prevWidth = width;
                },
                onHorizontalDragUpdate: (event) {
                  width = max((event.globalPosition.dx - origin.dx) + prevWidth,
                      style.mixWidth);
                  width = min(width, style.maxWidth);
                  setState(() {});
                },
                child: Container(
                  color: style.color,
                  width: 3,
                ),
              ),
            ),
          ],
        ));
  }
}
