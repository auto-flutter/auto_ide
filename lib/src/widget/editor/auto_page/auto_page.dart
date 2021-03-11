import 'dart:async';
import 'dart:io';

import 'package:auto_core/auto_core.dart';
import 'package:auto_ide/generated/l10n.dart';
import 'package:auto_ide/protos/application.pbserver.dart';
import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/provider/application_list.dart';
import 'package:auto_ide/src/provider/settings.dart';
import 'package:auto_ide/src/provider/style.dart';
import 'package:auto_ide/src/storage/kv_storage.dart';
import 'package:auto_ide/src/widget/editor/editor.dart';
import 'package:auto_ide/src/widget/reorderable_wrap.dart';
import 'package:auto_ide/src/widget/right_listener.dart';
import 'package:auto_ide/src/widget/tool/application_manager.dart';
import 'package:auto_ide/src/widget/tool/file_manager.dart';
import 'package:auto_ide/src/widget/tool/tool.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:bubble/bubble.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as pathHelper;
import 'package:provider/provider.dart';

import '../report_page.dart';
import 'checkpoint_editor.dart';

part 'auto_player.dart';

class AutoPage extends StatefulWidget {
  final ViewKey viewKey;
  final String path;

  AutoPage({@required this.viewKey, @required this.path})
      : super(key: ValueKey(path));

  @override
  _AutoPageState createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  bool willAccept = false;
  bool showRemoteInput = false;
  bool disableKeyboard = false;
  TextEditingController remoteInputController = TextEditingController();
  FocusNode remoteInputFocusNode = FocusNode();

  Duration delay = Duration(seconds: 5);
  Application selectApp;
  Application app;
  AutoPlayer autoPlayer;

  @override
  void initState() {
    super.initState();

    final controller = context.read<ApplicationConfigListController>();
    final kvStorage = context.read<KVStorage>();
    if (controller.current.isNotEmpty) {
      final id =
          kvStorage.get<String>('lastAppSelected', namespace: Namespace.auto);
      final appConfig = controller.current.firstWhere(
          (element) => element.application.id == id,
          orElse: () => controller.current.first);
      selectApp = appConfig.application;
      app = appConfig.application;
    }
    bool disableKeyboard =
        kvStorage.get<bool>('disableKeyboard', namespace: Namespace.auto);
    this.disableKeyboard = disableKeyboard == true;

    _loadAutoPlayer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final list = context.watch<ApplicationConfigListController>().current;
    if (selectApp != null &&
        !list.any((element) => selectApp == element.application)) {
      if(app==selectApp){
        app=null;
        autoPlayer?.detach();
      }
      selectApp = null;
    }
  }

  @override
  void dispose() {
    autoPlayer?.removeListener(this._onAutPlayerUpdate);
    autoPlayer?.close();
    super.dispose();
  }

  void _loadAutoPlayer() async {
    AutoScript autoScript = await AutoScript.load(widget.path);
    if (!mounted) {
      return;
    }
    autoPlayer = AutoPlayer(savePath: widget.path, initialScript: autoScript);
    autoPlayer.addListener(_onAutPlayerUpdate);
    if (app != null) {
      autoPlayer.attach(RemoteApp(host: app.host, port: app.port));
    }
  }

  void _onAutPlayerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void onAppChanged(Application application) {
    setState(() {
      this.app = application;
      this.selectApp = application;
      autoPlayer?.attach(RemoteApp(host: app.host, port: app.port));
      context
          .read<KVStorage>()
          .set('lastAppSelected', app.id, namespace: Namespace.auto);
    });
  }

  void _handelDelayRightTap(BuildContext context) {
    Duration newValue;
    BotToast.showAttachedWidget(
        wrapAnimation: (_, __, child) {
          return ToastSafeArea(child: child);
        },
        onClose: () {
          if (newValue != null) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              if (!mounted) {
                return;
              }
              setState(() {
                delay = newValue;
              });
            });
          }
        },
        backgroundColor: Colors.black54,
        targetContext: context,
        preferDirection: PreferDirection.bottomCenter,
        attachedBuilder: (cancel) => DelaySelector(
            initialDelay: delay,
            onChanged: (v) {
              newValue = v;
            }));
  }

  void _handleReplayTap() async {
    try {
      final customPath = context.read<SettingsController>().get<String>(SettingKey.autoUtil);
      final path = customPath?.isNotEmpty==true? customPath : mainCmd;
      final report = await autoPlayer.replay(force: true, autoUtilPath: path);

      VoidCallback onSave = () async {
        final newName = pathHelper.setExtension(widget.path, '.autor');
        final savePath = await getSavePath(
            initialDirectory: pathHelper.dirname(newName),
            suggestedName: pathHelper.basename(newName));
        if (savePath != null) {
          report.save(savePath);
        }
      };

      if (report.basicInfo.ok) {
        ToastUtil.dialog(
            leftText: S.current.ok,
            rightText: S.current.viewDetails,
            content: S.current.autoPageMatchTestPassed,
            onTapRight: () {
              context.read<EditorController>().open(
                  key: ViewKey(
                      namespace: Namespace.report, id: IdGenerator.nextId()),
                  tab: context.i18.reportPageTab,
                  contentIfAbsent: (_) => ReportPage(
                        initialReport: ()=>Future.value(report),
                        onSave: onSave,
                      ));
            });
      } else {
        ToastUtil.dialog(
            leftText: S.current.ok,
            rightText: S.current.viewDetails,
            content: S.current.autoPageMatchTestFailed,
            onTapRight: () {
              context.read<EditorController>().open(
                  key: ViewKey(
                      namespace: Namespace.report, id: IdGenerator.nextId()),
                  tab: context.i18.reportPageTab,
                  contentIfAbsent: (_) => ReportPage(
                    initialReport: ()=>Future.value(report),
                        onSave: onSave,
                      ));
            });
      }
    } catch (e, s) {
      _log.severe('_handleReplayTap', e, s);
      ToastUtil.error(e);
    }
  }

  Widget buildStartButton() {
    VoidCallback onPressed;
    String tooltip = context.i18.autoPageStartTip;
    if (autoPlayer == null) {
    } else if ((autoPlayer.isCompleted || autoPlayer.isIdle) &&
        autoPlayer.hasRemoteApp) {
      onPressed = () {
        autoPlayer.start(force: true,disableKeyboard: disableKeyboard);
      };
    } else if (autoPlayer.isStarted && autoPlayer.hasRemoteApp) {
      tooltip=context.i18.autoPagePauseTip;
      onPressed = () {
        autoPlayer.pause();
      };
    } else if (autoPlayer.isPaused && autoPlayer.hasRemoteApp) {
      tooltip=context.i18.autoPageContinueTip;
      onPressed = () {
        autoPlayer.continue1();
      };
    }

    IconData icon;
    if(autoPlayer?.isStarted==true){
      icon=Icons.pause_rounded;
    }else if(autoPlayer?.isPaused==true){
      icon=Icons.play_arrow_outlined;
    }else{
      icon=Icons.play_arrow_rounded;
    }
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: Colors.lightBlue,
      tooltip: tooltip,
    );
  }

  Widget buildDoneButton() {
    VoidCallback onPressed;
    if (autoPlayer == null) {
    } else if ((autoPlayer.isStarted || autoPlayer.isPaused) &&
        autoPlayer.hasRemoteApp) {
      onPressed = () {
        autoPlayer.stopAndSave();
      };
    }
    return IconButton(
      icon: Icon(Icons.done_rounded),
      onPressed: onPressed,
      color: Colors.green,
      tooltip: context.i18.autoPageStopSaveTip,
    );
  }

  Widget buildStopButton() {
    VoidCallback onPressed;
    if (autoPlayer == null) {
    } else if ((autoPlayer.isStarted || autoPlayer.isPaused) &&
        autoPlayer.hasRemoteApp) {
      onPressed = () {
        autoPlayer.stop();
      };
    } else if (autoPlayer.isReplaying && autoPlayer.hasRemoteApp) {
      onPressed = () {
        autoPlayer.stopReplay();
      };
    }
    return IconButton(
      icon: Icon(Icons.stop_rounded),
      onPressed: onPressed,
      color: Colors.redAccent,
      tooltip: context.i18.autoPageStopTip,
    );
  }

  Widget buildReplayButton() {
    VoidCallback onPressed;
    if (autoPlayer == null) {
    } else if (autoPlayer.isCompleted &&
        autoPlayer.hasRemoteApp &&
        autoPlayer.autoScriptAvailable) {
      onPressed = _handleReplayTap;
    }
    return IconButton(
      icon: Icon(Icons.replay_rounded),
      onPressed: onPressed,
      color: Colors.lightBlue,
      tooltip: context.i18.autoPageReplayTip,
    );
  }

  Widget buildCheckpointButton() {
    VoidCallback onPressed;
    if (autoPlayer == null) {
    } else if ((autoPlayer.isStarted || autoPlayer.isPaused) &&
        autoPlayer.hasRemoteApp) {
      onPressed = () {
        autoPlayer.addCheckpoint();
      };
    }
    return IconButton(
      icon: Icon(Icons.camera_rounded),
      onPressed: onPressed,
      color: Colors.lightBlue,
      tooltip: context.i18.autoPageAddCheckpointTip,
    );
  }

  Widget buildDisableKeyboardSwitch() {
    ValueChanged<bool> onChanged;
    Color color = Theme.of(context).disabledColor;
    if (autoPlayer == null) {
    } else if ((autoPlayer.isCompleted || autoPlayer.isIdle) &&
        autoPlayer.hasRemoteApp) {
      onChanged = (v) {
        setState(() {
          disableKeyboard = v;
        });
        context
            .read<KVStorage>()
            .set('disableKeyboard', disableKeyboard, namespace: Namespace.auto);
      };
      color = Colors.lightBlue;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Tooltip(
          message: context.i18.autoPageDisableKeyboardTip,
          child: Switch(
            activeColor: Colors.lightBlue,
            thumbColor: MaterialStateProperty.all(color),
            onChanged: onChanged,
            value: disableKeyboard,
          ),
        ),
        Container(
          width: 32,
          child: Text(
            disableKeyboard ? 'ON' : 'OFF',
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        )
      ],
    );
  }

  Widget buildInputButton() {
    VoidCallback onPressed;
    if (autoPlayer == null) {
    } else if ((autoPlayer.isStarted || autoPlayer.isPaused) &&
        autoPlayer.hasRemoteApp) {
      onPressed = () {
        setState(() {
          showRemoteInput = !showRemoteInput;
          if (showRemoteInput) {
            remoteInputFocusNode.requestFocus();
          }
        });
      };
    }
    return IconButton(
      icon: Icon(Icons.keyboard_rounded),
      onPressed: onPressed,
      color: Colors.lightBlue,
      tooltip: context.i18.autoPageOpenRemoteInput,
    );
  }

  Widget buildDelayButton() {
    VoidCallback onPressed;
    Color color = Theme.of(context).disabledColor;
    if (autoPlayer == null) {
    } else if ((autoPlayer.isStarted || autoPlayer.isPaused) &&
        autoPlayer.hasRemoteApp) {
      onPressed = () {
        autoPlayer.addDelay(delay);
      };
      color = Colors.lightBlue;
    }
    return Builder(
      builder: (context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RightClickListener(
            onRightClick: (_) => _handelDelayRightTap(context),
            child: IconButton(
              icon: Icon(Icons.more_time_rounded),
              onPressed: onPressed,
              color: Colors.lightBlue,
              tooltip: context.i18.autoPageAddDelayTip,
            ),
          ),
          Text(
            _formatDuration(delay),
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          )
        ],
      ),
    );
  }

  Widget buildDependencies() {
    return _Dependencies(
      path: widget.path,
      onTapItem: (path) {
        IOOverrides.runZoned(() {
          IOOverrides.current
              .setCurrentDirectory(pathHelper.dirname(widget.path));
          context
              .read<FileManagerController>()
              .openFile(path: File(path).absolute.path);
        });
      },
      dependencies: autoPlayer?.dependencies() ?? [],
      onReorder: autoPlayer?.reorderDependencies ?? (_, __) {},
      onCloseItem: (index) {
        autoPlayer.removeDependencyAt(index);
      },
      onAddItem: (path) {
        assert(pathHelper.isAbsolute(path));
        assert(pathHelper.isAbsolute(widget.path));
        final rootPath = pathHelper.dirname(widget.path);
        final relativePath = pathHelper.relative(path, from: rootPath);
        autoPlayer.addDependency(relativePath);
      },
    );
  }

  Widget buildCheckpointEditor() {
    return CheckpointEditor(
      checkpoints: autoPlayer?.checkpoints() ?? [],
      onAddMatchPosition: (name, ratioRect) {
        autoPlayer.addMatchPosition(name, ratioRect);
        return true;
      },
      onRemoveMatchPosition: (name, ratioRect) {
        autoPlayer.removeMatchPosition(name, ratioRect);
        return true;
      },
    );
  }

  Widget buildRemoteInput(EditorStyle style) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: style.formSecondaryColor,
      ),
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 8),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: TextField(
        focusNode: remoteInputFocusNode,
        controller: remoteInputController,
        textInputAction: TextInputAction.send,
        onSubmitted: (text) {
          remoteInputController.clear();
          remoteInputFocusNode.requestFocus();
          autoPlayer?.enterText(text);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: context.i18.autoPageRemoteInputHint,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = EditorStyle();
    return Container(
      padding: EdgeInsets.all(32).copyWith(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.circular(8),
            color: style.formColor,
            child: Container(
              padding: EdgeInsets.only(left: 24),
              constraints: BoxConstraints(minHeight: 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildStartButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildDoneButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildStopButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildReplayButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildDisableKeyboardSwitch(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildCheckpointButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildInputButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildDelayButton(),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: AppDropButton(
                            value: this.selectApp,
                            onChanged: autoPlayer == null ||
                                    autoPlayer.isIdle ||
                                    autoPlayer.isCompleted
                                ? onAppChanged
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showRemoteInput &&
                      (autoPlayer.isStarted || autoPlayer.isPaused) &&
                      autoPlayer.hasRemoteApp)
                    buildRemoteInput(style),
                ],
              ),
            ),
          ),
          Tooltip(
            message: context.i18.autoPageDependenciesTip,
            child: Container(
              padding: EdgeInsets.only(top: 24, bottom: 16),
              child: SelectableText(context.i18.autoPageDependenciesTitle,
                  style: Theme.of(context).textTheme.subtitle1),
            ),
          ),
          buildDependencies(),
          if (autoPlayer?.checkpoints()?.isNotEmpty == true)
            Tooltip(
              message: context.i18.autoPageCheckpointsTip,
              child: Container(
                padding: EdgeInsets.only(top: 24, bottom: 16),
                child: SelectableText(context.i18.autoPageCheckpointsTitle,
                    style: Theme.of(context).textTheme.subtitle1),
              ),
            ),
          Expanded(child: buildCheckpointEditor())
        ],
      ),
    );
  }
}

class AppDropButton extends StatefulWidget {
  final Application value;

  final ValueChanged<Application> onChanged;

  const AppDropButton({Key key, this.value, @required this.onChanged})
      : super(key: key);

  @override
  _AppDropButtonState createState() => _AppDropButtonState();
}

class _AppDropButtonState extends State<AppDropButton> {
  List<DropdownMenuItem<Application>> buildMenuList(
      ApplicationConfigListController controller) {
    return controller.current
        .map((e) => DropdownMenuItem<Application>(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(
                      text: e.application.name,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  if (e.online)
                    TextSpan(
                        text: '  (online)',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w600)),
                ]),
              ),
              value: e.application,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<EditorStyle>();
    ApplicationConfigListController controller =
        context.watch<ApplicationConfigListController>();
    return Container(
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          color: style.formSecondaryColor,
          borderRadius: BorderRadius.circular(4)),
      constraints: BoxConstraints(minWidth: 100, maxWidth: 250),
      height: 40,
      child: InkWell(
        onTap: controller.current.isEmpty
            ? () {
                final controller = context.read<ApplicationManagerController>();
                if (controller.hasListener()) {
                  controller.openAddApplication();
                } else {
                  final toolController = context.read<ToolController>();
                  toolController.toggleTool(
                      viewKey: ConstViewKey.applicationManager);
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    controller.openAddApplication();
                  });
                }
              }
            : null,
        child: DropdownButtonHideUnderline(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DropdownButton<Application>(
              isExpanded: true,
              hint: Text(context.i18.autoPageSelectApp),
              disabledHint: Text(context.i18.autoPageConfigApp),
              onChanged: widget.onChanged,
              style: TextStyle(fontSize: 14),
              icon: Icon(Icons.expand_more),
              iconSize: 16,
              value: widget.value,
              items: buildMenuList(controller),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDuration(Duration value) {
  if (value.inMilliseconds < 1000) {
    return '${value.inMilliseconds}ms';
  } else if (value.inSeconds < 60) {
    return '${value.inSeconds}s';
  } else {
    final total = value.inSeconds;
    final s = total % 60;
    return '${total ~/ 60}min ${s == 0 ? '' : '${s}s'}';
  }
}

class DelaySelector extends StatefulWidget {
  final ValueChanged<Duration> onChanged;
  final Duration initialDelay;

  const DelaySelector({Key key, this.onChanged, this.initialDelay})
      : super(key: key);

  @override
  _DelaySelectorState createState() => _DelaySelectorState();
}

class _DelaySelectorState extends State<DelaySelector> {
  Duration value;
  Duration sliderValue;

  @override
  void initState() {
    super.initState();
    value = widget.initialDelay ?? Duration.zero;
    sliderValue = Duration(seconds: value.inSeconds.clamp(0, 60));
  }

  void setValue(Duration newValue) {
    setState(() {
      this.value = newValue;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<EditorStyle>();

    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: style.formSecondaryColor,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              context.i18.autoPageDelayToastTitle(_formatDuration(value)),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: style.hintColor),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            ),
            child: Slider(
              onChanged: (double value) {
                sliderValue = Duration(seconds: value.round());
                setValue(sliderValue);
              },
              label: '${sliderValue.inSeconds} s',
              divisions: 60,
              max: 60,
              value: sliderValue.inSeconds.toDouble(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setValue(Duration(seconds: 1));
                },
                child: Text('1s'),
              ),
              TextButton(
                onPressed: () {
                  setValue(Duration(seconds: 2));
                },
                child: Text('2s'),
              ),
              TextButton(
                onPressed: () {
                  setValue(Duration(seconds: 5));
                },
                child: Text('5s'),
              ),
              TextButton(
                onPressed: () {
                  setValue(Duration(seconds: 10));
                },
                child: Text('10s'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setValue(Duration(minutes: 1));
                },
                child: Text('1min'),
              ),
              TextButton(
                onPressed: () {
                  setValue(Duration(minutes: 2));
                },
                child: Text('2min'),
              ),
              TextButton(
                onPressed: () {
                  setValue(Duration(minutes: 5));
                },
                child: Text('5min'),
              ),
              TextButton(
                onPressed: () {
                  setValue(Duration(minutes: 10));
                },
                child: Text('10min'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Dependencies extends StatefulWidget {
  final String path;
  final List<String> dependencies;
  final ReorderCallback onReorder;
  final InFunc<int> onCloseItem;
  final InFunc<String> onAddItem;
  final InFunc<String> onTapItem;

  const _Dependencies(
      {Key key,
      this.path,
      this.dependencies,
      this.onReorder,
      this.onCloseItem,
      this.onAddItem,
      this.onTapItem})
      : super(key: key);

  @override
  __DependenciesState createState() => __DependenciesState();
}

class __DependenciesState extends State<_Dependencies> {
  bool willAccept = false;

  Widget _buildDragTarget(Widget child) {
    return DragTarget<FileDragEvent>(onWillAccept: (event) {
      if (pathHelper.extension(event.path) != '.auto' ||
          event.path == widget.path) {
        return false;
      }
      setState(() {
        willAccept = true;
      });

      return true;
    }, onAccept: (event) {
      setState(() {
        willAccept = false;
        widget.onAddItem(event.path);
        if (widget.dependencies.length > 0) {
          _popupTip();
        }
      });
    }, onLeave: (_) {
      if (willAccept) {
        setState(() {
          willAccept = false;
        });
      }
    }, builder: (BuildContext context, List<FileDragEvent> candidateData,
        List<dynamic> rejectedData) {
      return child;
    });
  }

  void _popupTip() {
    final kv = context.read<KVStorage>();
    final result = kv.get<bool>('dragTip', namespace: Namespace.auto);
    if (result == false) {
      return;
    }
    kv.set('dragTip', false, namespace: Namespace.auto);

    final FileManagerStyle style = context.read<FileManagerStyle>();
    BotToast.showAttachedWidget(
        preferDirection: PreferDirection.bottomCenter,
        backgroundColor: Colors.black54,
        attachedBuilder: (cancel) => Bubble(
              margin: BubbleEdges.only(left: 8, top: 10),
              nip: BubbleNip.no,
              padding: BubbleEdges.symmetric(horizontal: 24),
              color: style.newAutoFileTipColor,
              child: Text(context.i18.autoPageDependenciesOrderHint,
                  style: TextStyle(fontSize: 14)),
            ),
        targetContext: context);
  }

  Widget buildItem(int index, EditorStyle style) {
    final path = widget.dependencies[index];
    final String name = pathHelper.basenameWithoutExtension(path);
    return ElevatedButton(
        style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor:
                MaterialStateProperty.all(style.dependencyButtonColor)),
        onPressed: () {
          widget.onTapItem(path);
        },
        child: Container(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: 14,
                  splashRadius: 16,
                  constraints: BoxConstraints(),
                  icon: Icon(
                    Icons.close_sharp,
                  ),
                  onPressed: () {
                    widget.onCloseItem(index);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> buildDependencies(EditorStyle style) {
    List<Widget> children = <Widget>[];
    for (int i = 0; i < widget.dependencies.length; i++) {
      children.add(buildItem(i, style));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    final style = EditorStyle();
    return _buildDragTarget(
      Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        constraints: BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
            border: Border.all(
                width: 3,
                color: willAccept ? style.activeBorderColor : style.formColor),
            color: style.formColor,
            borderRadius: BorderRadius.circular(8)),
        child: widget.dependencies.isEmpty
            ? Center(
                child: Text(
                  context.i18.autoPageDependenciesHint,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: style.hintColor),
                ),
              )
            : Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(4),
                child: ReorderableWrap(
                  onReorder: widget.onReorder,
                  itemPadding: EdgeInsets.only(right: 12, bottom: 16),
                  children: buildDependencies(style),
                ),
              ),
      ),
    );
  }
}
