import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_core/auto_core.dart';
import 'package:auto_core/protos/replay_report_info.pb.dart';
import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:auto_ide/src/widget/app_info_panel.dart';
import 'package:auto_ide/src/widget/log_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../measure_size.dart';

class ReportPage extends StatefulWidget {
  final OutFutureFunc<PlaybackReport> initialReport;
  final VoidCallback onSave;

  ReportPage({@required this.initialReport, this.onSave})
      : super(key: ValueKey(initialReport));

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  PlaybackReport report;

  List<String> logList;
  final ScrollController scrollController = ScrollController();
  final ScrollController logScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.initialReport().then((value) {
      report = value;
      if (report.log != null && report.log.isNotEmpty) {
        logList = utf8.decode(report.log).split('\n');
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget wrap({Widget child}) {
    final style = context.watch<EditorStyle>();
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: style.formColor,
      child: Container(
        padding: EdgeInsets.all(12.0).copyWith(left: 24),
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }

  Widget buildBasicInfoPanel(EditorStyle style) {
    final basicInfo = report.basicInfo;

    return wrap(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: SelectableText(
              basicInfo.ok
                  ? context.i18.reportPageSuccessTitle
                  : context.i18.reportPageFailureTitle,
              style: Theme.of(context).textTheme.headline5.copyWith(
                  color: basicInfo.ok ? Colors.green : Colors.redAccent),
            ),
          ),
          if (basicInfo.hasErrorReason())
            Container(
              margin: EdgeInsets.only(top: 8),
              child: SelectableText(
                context.i18.reportPageErrorReason(basicInfo.errorReason),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          if (basicInfo.hasAppInfoOfRecorder())
            Container(
              margin: EdgeInsets.only(top: 12),
              child: ProxyProvider<EditorStyle, ApplicationInfoPanelStyle>(
                update: (BuildContext context, value, previous) {
                  return ApplicationInfoPanelStyle(
                      panelColor: value.formSecondaryColor);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            context.i18.reportPageOriginalAppTitle,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          AppInfoPanel(basicInfo.appInfoOfRecorder),
                        ],
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            context.i18.reportPageTestAppTitle,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          AppInfoPanel(basicInfo.appInfoOfPlayer),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          if (widget.onSave != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 2),
              child: ElevatedButton(
                  onPressed: widget.onSave,
                  style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor:
                          MaterialStateProperty.all(style.primaryButtonColor)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    child: Text(context.i18.save),
                  )),
            )
        ],
      ),
    );
  }

  Widget buildLogView(EditorStyle style) {
    return Container(
      constraints: BoxConstraints(maxHeight: 600),
      padding: const EdgeInsets.only(top: 16.0),
      child: wrap(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: SelectableText(
                context.i18.reportPageLogTitle,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: style.formSecondaryColor,
                  borderRadius: BorderRadius.circular(8)),
              child: LogView(
                getLog: (index) => logList[index],
                logTotal: logList.length,
                scrollController: logScrollController,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget buildMatchError(EditorStyle style) {
    final List<Widget> children = <Widget>[];
    children.addAll(report.matchErrors.map((e) =>
        buildSnapshot(e.imageOfRecorder, e.imageOfPlayer, e.matchPosition)));
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: wrap(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: SelectableText(
                context.i18.reportPageCheckpointTitle,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          ],
        ),
      ),
    );
  }

  Widget buildSnapshot(
      Uint8List origin, Uint8List test, RatioRect matchPosition) {
    final style = context.watch<EditorStyle>();
    return Container(
      height: 500,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
            alignment: Alignment(0.9, 0.0),
            child: _ImageView(
              data: origin,
              position: matchPosition,
            ),
          )),
          Center(child: Icon(Icons.compare_arrows)),
          Expanded(
              child: Container(
            alignment: Alignment(-0.9, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                color: style.formSecondaryColor,
                child: Image.memory(
                  test,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (report == null) {
      return SizedBox.shrink();
    }

    final style = context.watch<EditorStyle>();
    return Container(
      padding: EdgeInsets.all(32).copyWith(top: 24, right: 16),
      child: Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBasicInfoPanel(style),
                if (report.matchErrors.isNotEmpty) buildMatchError(style),
                if (logList != null && logList.isNotEmpty) buildLogView(style)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageView extends StatefulWidget {
  final Uint8List data;
  final RatioRect position;

  const _ImageView({Key key, this.data, this.position}) : super(key: key);

  @override
  __ImageViewState createState() => __ImageViewState();
}

class __ImageViewState extends State<_ImageView> {
  Rect imageRect = Rect.zero;

  @override
  Widget build(BuildContext context) {
    final rect = RatioRectHelper.transform(imageRect, widget.position);
    final style = context.watch<EditorStyle>();
    return Stack(
      fit: StackFit.loose,
      children: [
        MeasureSize(
          onChange: (Size arg) {
            setState(() {
              imageRect = Rect.fromLTWH(0, 0, arg.width, arg.height);
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              color: style.formSecondaryColor,
              child: Image.memory(
                widget.data,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned.fromRect(
            rect: rect,
            child: Container(
              height: rect.height,
              width: rect.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(width: 1.5, color: Colors.redAccent)),
            ))
      ],
    );
  }
}
