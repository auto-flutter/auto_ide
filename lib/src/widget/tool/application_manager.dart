import 'package:auto_ide/protos/application.pbserver.dart';
import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/common/id_generator.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:auto_ide/src/widget/editor/application_page.dart';
import 'package:auto_ide/src/widget/editor/editor.dart';
import 'package:auto_ide/src/widget/hover_listener.dart';
import 'package:auto_ide/src/widget/material_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class ApplicationManagerListener {
  void onOpenAddApplication();
}

class ApplicationManagerController with GenericListenable<ApplicationManagerListener> {
  void openAddApplication() {
    foreach((entry) {
      entry.onOpenAddApplication();
    });
  }
}

class ApplicationManager extends StatefulWidget {
  @override
  _ApplicationManagerState createState() => _ApplicationManagerState();
}

class _ApplicationManagerState extends State<ApplicationManager> implements ApplicationManagerListener{

  ApplicationManagerController controller;


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final old = controller;
    controller = context.watch<ApplicationManagerController>();
    if (old != controller) {
      controller.addListener(this);
      old?.removeListener(this);
    }
  }

  @override
  void dispose() {
    controller?.removeListener(this);
    super.dispose();
  }

  @override
  void onOpenAddApplication() {
    _addApplication();
  }

  void _addApplication() {
    final controller = context.read<EditorController>();
    controller.open(
        key: ConstViewKey.addApplication,
        tab: context.i18.applicationManagerAddTab,
        contentIfAbsent: (_) => ApplicationPage(
              title: context.i18.applicationManagerAddPageTitle,
              viewKey: ConstViewKey.addApplication,
              onSave: _onAddSave,
            ));
  }

  void _openEditPage(
      {@required String appName,
      @required String host,
      @required int port,
      @required String id}) {
    final controller = context.read<EditorController>();
    final key = ViewKey(namespace: Namespace.applicationManager, id: id);
    controller.open(
        key: key,
        tab: appName,
        contentIfAbsent: (_) => ApplicationPage(
              initialName: appName,
              initialHost: host,
              initialPort: port,
              title: context.i18.applicationManagerEditPageTitle,
              viewKey: key,
              onSave: (result) => _onEditSave(result, id),
            ));
  }

  void _onAddSave(ApplicationPageResult result) {
    final controller = context.read<ApplicationConfigListController>();
    controller.add(Application(
        name: result.name,
        host: result.host,
        port: result.port,
        id: IdGenerator.nextId()));
  }

  void _onEditSave(ApplicationPageResult result, String id) {
    final controller = context.read<ApplicationConfigListController>();
    controller.update(Application(
        name: result.name, host: result.host, port: result.port, id: id));
  }

  void _deleteItem(String id) {
    final controller = context.read<ApplicationConfigListController>();
    final editorController = context.read<EditorController>();
    final key = ViewKey(namespace: Namespace.applicationManager, id: id);
    controller.remove(id);
    editorController.close(key);
  }

  Future<void> _refreshItem(String id)  {
    final controller = context.read<ApplicationConfigListController>();
    return controller.refresh(id);
  }

  Future<void> _refreshAll()  {
    final controller = context.read<ApplicationConfigListController>();
    return controller.refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<ApplicationManagerStyle>();
    return MaterialWrapper(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.i18.applicationManagerTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: style.titleFontSize),
                  ),
                )),
                IconButton(
                  tooltip: context.i18.applicationManagerAddTip,
                  onPressed: _addApplication,
                  splashRadius: style.splashRadius,
                  iconSize: style.iconSize,
                  icon: Icon(Icons.add),
                ),
                _RefreshButton(
                  tooltip: context.i18.applicationManagerRefreshAllTip,
                  onPressed: _refreshAll,
                )
              ],
            ),
          ),
          Divider(
            height: 1.5,
            thickness: 3,
          ),
          Expanded(
            child: Scrollbar(
                // isAlwaysShown: true,
                child: Consumer<ApplicationConfigListController>(
              builder: (_, controller, __) => ListView.builder(
                itemCount: controller.current.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = controller.current[index];
                  return InkWell(
                    onTap: () {
                      _openEditPage(
                          host: item.application.host,
                          port: item.application.port,
                          appName: item.application.name,
                          id: item.application.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: HoverListener(
                        builder: (_, hover) => Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: item.application.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  if (item.online)
                                    TextSpan(
                                        text: '  (online)',
                                        style: TextStyle(

                                            color: Colors.green,
                                            fontWeight: FontWeight.w600)),
                                ]),
                              ),
                            )),
                            // Text('device $index'),
                            Offstage(
                              offstage: !hover,
                              child: IconButton(
                                tooltip: context.i18.delete,
                                onPressed: () {
                                  _deleteItem(item.application.id);
                                },
                                splashRadius: style.splashRadius,
                                iconSize: style.iconSize,
                                icon: Icon(Icons.delete_outline),
                              ),
                            ),
                            Offstage(
                              offstage: !hover,
                              child: _RefreshButton(
                                tooltip: context.i18.refresh,
                                onPressed: ()  {
                                  return _refreshItem(item.application.id);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )),
          ),
        ],
      ),
    );
  }


}

class _RefreshButton extends StatefulWidget {
  final OutFutureFunc<void> onPressed;
  final String tooltip;

  const _RefreshButton({Key key,@required this.onPressed, this.tooltip}) : super(key: key);

  @override
  __RefreshButtonState createState() => __RefreshButtonState();
}

class __RefreshButtonState extends State<_RefreshButton> {
  Future<void> task;

  void onPressed() {
    setState(() {
      task = widget.onPressed();
      task.whenComplete(() {
        if (!mounted) return;
        setState(() {
          task = null;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<ApplicationManagerStyle>();
    return IconButton(
      tooltip: widget.tooltip,
      onPressed: task == null ? onPressed : null,
      splashRadius: style.splashRadius,
      iconSize: style.iconSize,
      icon: Icon(Icons.refresh),
    );
  }
}
