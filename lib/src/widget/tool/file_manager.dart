import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:auto_core/auto_core.dart';
import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/common/view_key.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:auto_ide/src/storage/kv_storage.dart';
import 'package:auto_ide/src/widget/editor/auto_page/auto_page.dart';
import 'package:auto_ide/src/widget/editor/report_page.dart';
import 'package:auto_ide/src/widget/proxy_init_state.dart';
import 'package:auto_ide/src/widget/editor/editor.dart';
import 'package:auto_ide/src/widget/editor/input_page.dart';
import 'package:auto_ide/src/widget/editor/unsupported_page.dart';
import 'package:auto_ide/src/widget/right_menu.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as pathHelper;
import 'package:provider/provider.dart';

import '../custom_expansion_tile.dart';
import '../draggable_proxy.dart';
import '../material_wrapper.dart';
import '../measure_size.dart';
import '../right_listener.dart';

class FileDragEvent {
  final String path;

  FileDragEvent(this.path);
}

abstract class FileManagerListener {
  void onOpenFile({@required String path});
}

class FileManagerController with GenericListenable<FileManagerListener> {
  void openFile({@required String path}) {
    foreach((entry) {
      entry.onOpenFile(path: path);
    });
  }
}

abstract class _InnerFileManagerApi {
  List<String> _getAllDir(String path);

  List<String> _getAllFile(String path);
}

class FileManager extends StatefulWidget {
  final String rootPath;

  const FileManager({Key key, @required this.rootPath}) : super(key: key);

  @override
  _FileManagerState createState() => _FileManagerState();
}

class _FileManagerState extends State<FileManager>
    implements _InnerFileManagerApi, FileManagerListener {
  final Map<String, List<String>> allFile = <String, List<String>>{};
  final Map<String, List<String>> allDir = <String, List<String>>{};
  StreamSubscription<FileSystemEvent> subscription;
  final ScrollController scrollController = ScrollController();
  final PageStorageBucket bucket = PageStorageBucket();
  FileManagerController controller;

  @override
  void initState() {
    super.initState();
    subscription = Directory(widget.rootPath)
        .watch(
            recursive: true,
            events: FileSystemEvent.create |
                FileSystemEvent.delete |
                FileSystemEvent.move)
        .listen((event) {
      String parentPath;
      if (event.isDirectory) {
        parentPath = Directory(event.path).parent.absolute.path;
      } else {
        parentPath = pathHelper.dirname(event.path);
      }
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _load(parentPath);
        if(mounted){
          setState(() {});
        }
      });
      SchedulerBinding.instance.ensureVisualUpdate();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final old = controller;
    controller = context.watch<FileManagerController>();
    if (old != controller) {
      controller.addListener(this);
      old?.removeListener(this);
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    controller?.removeListener(this);
  }

  @override
  void didUpdateWidget(covariant FileManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rootPath != widget.rootPath) {
      allDir.clear();
      allFile.clear();
    }
  }

  List<String> _getAllDir(String path) {
    if (!allDir.containsKey(path)) {
      _load(path);
    }
    return allDir[path];
  }

  List<String> _getAllFile(String path) {
    if (!allFile.containsKey(path)) {
      _load(path);
    }
    return allFile[path];
  }

  @override
  void onOpenFile({@required String path}) async {
    assert(pathHelper.isAbsolute(path));
    assert(path != null);
    final controller = context.read<EditorController>();
    final ViewKey key = ViewKey(namespace: Namespace.fileManager, id: path);

    FocusNode focusNode = bucket.readState(context, identifier: path);
    if (focusNode == null) {
      focusNode = FocusNode();
      bucket.writeState(context, focusNode, identifier: path);
    }
    focusNode.requestFocus();

    WidgetBuilder builder;
    if (pathHelper.extension(path) == '.auto') {
      builder = (_) => AutoPage(
            viewKey: key,
            path: path,
          );
    } else if (pathHelper.extension(path) == '.autor') {
      builder = (_) => ReportPage(initialReport: ()=>PlaybackReport.load(path),);
    } else {
      builder = (_) => UnsupportedPage();
    }

    controller.open(
        key: key,
        tab: pathHelper.basename(path),
        onTapTab: () {
          focusNode.requestFocus();
        },
        contentIfAbsent: builder);
  }

  void _load(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return;
    }
    final all = dir.listSync(followLinks: false);
    allFile[path] = <String>[];
    allDir[path] = <String>[];
    all.forEach((element) {
      if (element is Directory) {
        allDir[path].add(element.absolute.path);
      } else if (element is File) {
        allFile[path].add(element.absolute.path);
      }
    });
  }

  void _popupTip(BuildContext context) {
    final kv = context.read<KVStorage>();
    final result =
        kv.get<bool>('needNewAutoFileTip', namespace: Namespace.fileManager);
    if (result == false) {
      return;
    }
    kv.set('needNewAutoFileTip', false, namespace: Namespace.fileManager);

    final FileManagerStyle style = context.read<FileManagerStyle>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      BotToast.showAttachedWidget(
          preferDirection: PreferDirection.rightTop,
          backgroundColor: Colors.black54,
          attachedBuilder: (cancel) => Bubble(
                margin: BubbleEdges.only(left: 8, top: 10),
                nip: BubbleNip.leftTop,
                padding: BubbleEdges.symmetric(horizontal: 24),
                color: style.newAutoFileTipColor,
                child: Text(context.i18.fileManagerNewAutoFileTip,
                    style: TextStyle(fontSize: 14)),
              ),
          targetContext: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: bucket,
      child: Container(
        alignment: Alignment.topCenter,
        child: Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: MaterialWrapper(
              child: DirItem(
                initExpanded: true,
                headWrap: (_, child) =>
                    ProxyInitState(initStateCallback: _popupTip, child: child),
                path: widget.rootPath,
                key: ValueKey(widget.rootPath),
                managerApi: this,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DirItem extends StatefulWidget {
  final String path;
  final bool initExpanded;
  final _InnerFileManagerApi managerApi;
  final TransitionBuilder headWrap;

  const DirItem(
      {Key key,
      @required this.path,
      this.initExpanded,
      this.headWrap,
      @required this.managerApi})
      : super(key: key);

  @override
  _DirItemState createState() => _DirItemState();
}

class _DirItemState extends State<DirItem> {
  bool isExpanded;
  bool willAccept = false;
  bool loaded = false;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.initExpanded != null && widget.initExpanded) {
      isExpanded = true;
    } else {
      isExpanded = false;
    }
    _loadFocusNode();
  }

  void onExpansionChanged(bool value) {
    focusNode.requestFocus();
    setState(() {
      isExpanded = value;
    });
  }

  @override
  void didUpdateWidget(covariant DirItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _loadFocusNode();
    }
  }

  void _loadFocusNode() {
    final storage = PageStorage.of(context);
    FocusNode focusNode = storage.readState(context, identifier: widget.path);
    if (focusNode == null) {
      this.focusNode = FocusNode();
      storage.writeState(context, this.focusNode, identifier: widget.path);
    } else {
      this.focusNode = focusNode;
    }
  }

  void _newAutoFile() {
    final viewKey =
        ViewKey(namespace: Namespace.fileManager, id: 'new:' + widget.path);
    context.read<EditorController>().open(
        key: viewKey,
        tab:
            '${context.i18.fileManagerNewAutoFile} (${pathHelper.basename(widget.path)})',
        contentIfAbsent: (_) => InputPage(
              title: context.i18.fileManagerNewAutoFile,
              viewKey: viewKey,
              onSave: (Map<String, String> result) {
                assert(result['name'] != null);
                String name = result['name'];
                if (pathHelper.extension(name) == '') {
                  name = '$name.auto';
                }
                final file = File(pathHelper.join(widget.path, name))
                  ..createSync();
                context
                    .read<FileManagerController>()
                    .openFile(path: file.absolute.path);
              },
              formItemGroup: [
                FormItem(
                    title: context.i18.fileManagerNewFormFileName,
                    key: 'name',
                    require: true,
                    hint: ' example: test.auto (require)')
              ],
            ));
  }

  void _deleteFile() {
    Directory(widget.path).delete(recursive: true);
  }

  void _handleRightClick(Offset position) {
    focusNode.requestFocus();
    showRightMenu([
      MenuGroup(items: [
        MenuItem(text: context.i18.fileManagerNewAutoFile, onTap: _newAutoFile),
        MenuItem(text: context.i18.delete, onTap: _deleteFile),
      ]),
    ], padding: EdgeInsets.only(right: 48), target: position);
  }

  Widget _buildFileDragTarget(Widget child) {
    return DragTarget<FileDragEvent>(
        onWillAccept: (event) {
          if (pathHelper.dirname(event.path) == widget.path) {
            return false;
          }
          setState(() {
            willAccept = true;
          });
          return true;
        },
        onAccept: (event) async {
          setState(() {
            willAccept = false;
          });
          final file = File(event.path);
          final newPath =
              pathHelper.join(widget.path, pathHelper.basename(event.path));
          if(File(newPath).existsSync()){
            ToastUtil.error('File already exists');
            return;
          }
          await file.copy(newPath);
          file.delete();
        },
        onLeave: (_) {
          setState(() {
            willAccept = false;
          });
        },
        builder: (_, __, ___) => child);
  }

  List<Widget> buildChildren() {
    if (!isExpanded && !loaded) {
      //Lazy loading
      return [];
    }
    loaded = true;
    final managerApi = widget.managerApi;
    List<Widget> children = <Widget>[];
    managerApi._getAllDir(widget.path).forEach((e) {
      children.add(Padding(
        padding: const EdgeInsets.only(left: 8),
        child: DirItem(
          path: e,
          managerApi: widget.managerApi,
        ),
      ));
    });
    managerApi._getAllFile(widget.path).forEach((e) {
      children.add(Padding(
        padding: const EdgeInsets.only(left: 8),
        child: FileItem(path: e),
      ));
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    assert(pathHelper.isAbsolute(widget.path));
    final FileManagerStyle style = context.watch<FileManagerStyle>();
    return CustomExpansionTile(
      value: isExpanded,
      customHead: (_, animation) {
        Widget child = _buildFileDragTarget(
          RightClickListener(
            onRightClick: _handleRightClick,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: willAccept ? style.dragColor : null,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  onExpansionChanged(!isExpanded);
                },
                focusNode: focusNode,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Transform.rotate(
                        angle: math.pi * (1.5 + animation.value / 2),
                        child: Icon(
                          Icons.expand_more,
                          size: style.iconSize,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 4),
                        // color: focusNode.hasFocus ? style.focusColor : null,
                        child: Text(
                          pathHelper.basename(widget.path),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        if (widget.headWrap != null) {
          child = widget.headWrap(context, child);
        }

        return child;
      },
      children: buildChildren(),
    );
  }
}

class FileItem extends StatefulWidget {
  final String path;

  const FileItem({Key key, this.path}) : super(key: key);

  @override
  _FileItemState createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  FocusNode focusNode;
  Size myselfSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _loadFocusNode();
  }

  @override
  void didUpdateWidget(covariant FileItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _loadFocusNode();
    }
  }

  void _loadFocusNode() {
    final storage = PageStorage.of(context);
    FocusNode focusNode = storage.readState(context, identifier: widget.path);
    if (focusNode == null) {
      this.focusNode = FocusNode();
      storage.writeState(context, this.focusNode, identifier: widget.path);
    } else {
      this.focusNode = focusNode;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openEditPage() {
    final controller = context.read<FileManagerController>();
    controller.openFile(path: widget.path);
  }

  void _newAutoFile() {
    final parentPath = File(widget.path).parent.path;
    final viewKey =
        ViewKey(namespace: Namespace.fileManager, id: 'new:' + parentPath);
    context.read<EditorController>().open(
        key: viewKey,
        tab:
            '${context.i18.fileManagerNewAutoFile} (${pathHelper.basename(parentPath)})',
        contentIfAbsent: (_) => InputPage(
              title: context.i18.fileManagerNewAutoFile,
              viewKey: viewKey,
              onSave: (Map<String, String> result) {
                assert(result['name'] != null);
                String name = result['name'];
                if (pathHelper.extension(name) == '') {
                  name = '$name.auto';
                }
                final file =
                    File(pathHelper.join(File(widget.path).parent.path, name))
                      ..createSync();
                context
                    .read<FileManagerController>()
                    .openFile(path: file.absolute.path);
              },
              formItemGroup: [
                FormItem(
                    title: context.i18.fileManagerNewFormFileName,
                    key: 'name',
                    require: true,
                    hint: ' example: test.auto (require)')
              ],
            ));
  }

  void _deleteFile() {
    File(widget.path).delete();
    focusNode.unfocus();
    context
        .read<EditorController>()
        .close(ViewKey(namespace: Namespace.fileManager, id: widget.path));
  }

  void _handleRightClick(Offset position) {
    focusNode.requestFocus();
    showRightMenu([
      MenuGroup(items: [
        MenuItem(text: context.i18.fileManagerNewAutoFile, onTap: _newAutoFile),
        MenuItem(text: context.i18.delete, onTap: _deleteFile),
      ]),
    ], padding: EdgeInsets.only(right: 48), target: position);
  }

  @override
  Widget build(BuildContext context) {
    final FileManagerStyle style = context.watch<FileManagerStyle>();
    return DraggableProxy<FileDragEvent>(
      data: FileDragEvent(widget.path),
      feedback: IgnorePointer(
          child: Material(
        borderRadius: BorderRadius.circular(4),
        color: style.dragColor,
        child: Container(
          padding: const EdgeInsets.all(6.0),
          height: myselfSize.height,
          width: myselfSize.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _getIconWidget(pathHelper.extension(widget.path), style),
              ),
              Text(
                pathHelper.basename(widget.path),
              )
            ],
          ),
        ),
      )),
      child: MeasureSize(
        onChange: (size) {
          setState(() {
            myselfSize = size;
          });
        },
        child: RightClickListener(
          onRightClick: _handleRightClick,
          child: InkWell(
            focusNode: focusNode,
            borderRadius: BorderRadius.circular(4),
            onTap: _openEditPage,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _getIconWidget(
                        pathHelper.extension(widget.path), style),
                  ),
                  Text(
                    pathHelper.basename(widget.path),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getIconWidget(String extension, FileManagerStyle style) {
    if (extension == '.auto') {
      return SvgPicture.asset('asset/auto_icon.svg',
          width: style.iconSize,
          height: style.iconSize,
          color: style.autoFileColor);
    } else if (extension == '.autor') {
      return SvgPicture.asset('asset/auto_icon.svg',
          width: style.iconSize,
          height: style.iconSize,
          color: style.autorFileColor);
    } else {
      return Icon(
        Icons.insert_drive_file_outlined,
        size: style.iconSize,
      );
    }
  }
}
