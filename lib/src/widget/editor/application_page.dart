import 'dart:ui';
import 'package:auto_core/auto_core.dart';
import 'package:auto_core/protos/app_info.pbserver.dart';
import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:auto_ide/src/widget/editor/editor.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_info_panel.dart';
import '../focus_builder.dart';

class ApplicationPageResult {
  final String name;
  final String host;
  final int port;

  ApplicationPageResult({this.name, this.host, this.port});
}

class ApplicationPage extends StatefulWidget {
  final String initialName;
  final String initialHost;
  final int initialPort;
  final String title;
  final ViewKey viewKey;
  final InFunc<ApplicationPageResult> onSave;

  const ApplicationPage(
      {Key key,
      @required this.title,
      @required this.viewKey,
      this.initialName,
      this.initialHost,
      this.initialPort,
      this.onSave})
      : super(key: key);

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _host;
  int _port;
  AppInfo _appInfo;
  bool _checking = false;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  Widget buildFormItem(String title,
      {String hintText,
      String initialValue,
      FocusNode focusNode,
      FormFieldSetter<String> onSaved,
      List<TextInputFormatter> inputFormatters}) {
    return Row(
      children: [
        Container(
          width: 180,
          padding: const EdgeInsets.all(8.0).copyWith(right: 64),
          child: FocusBuilder(
            skipTraversal: true,
            builder: (_, focusNode) => SelectableText(
              title,
              style: Theme.of(context).textTheme.subtitle1,
              focusNode: focusNode,
            ),
          ),
        ),
        Expanded(
            child: Container(
          child: TextFormField(
            onSaved: onSaved,
            initialValue: initialValue,
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        )),
      ],
    );
  }

  Widget buildButton(
      {@required String text,
      VoidCallback onPressed,
      @required EditorStyle style,
      bool primary = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: MaterialStateProperty.all(primary
                ? style.primaryButtonColor
                : style.secondaryButtonColor)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 24),
          child: Text(text),
        ),
      ),
    );
  }

  void confirm() {
    _formKey.currentState.save();
    if (_name?.isNotEmpty != true) {
      return ToastUtil.emptyError(context.i18.applicationManagerAppName);
    }
    if (_host?.isNotEmpty != true) {
      return ToastUtil.emptyError(context.i18.applicationManagerHost);
    }
    if (_port == null) {
      return ToastUtil.nullError(context.i18.applicationManagerPort);
    }
    widget.onSave
        ?.call(ApplicationPageResult(name: _name, host: _host, port: _port));
    context.read<EditorController>().close(widget.viewKey);
  }

  void cancel() {
    context.read<EditorController>().close(widget.viewKey);
  }

  void check() async {
    _formKey.currentState.save();
    if (_host?.isNotEmpty != true) {
      return ToastUtil.emptyError(context.i18.applicationManagerHost);
    }
    if (_port == null) {
      return ToastUtil.nullError(context.i18.applicationManagerPort);
    }
    setState(() {
      _appInfo = null;
      _checking = true;
    });
    final app = RemoteApp(host: _host, port: _port);
    try {
      final result = await app.info();
      if (result.ok) {
        AppInfo appInfo = result.result;
        setState(() {
          _appInfo = appInfo;
        });
      } else {
        ToastUtil.error('Application not found');
      }
    } catch (e) {
      ToastUtil.error(e.toString());
      rethrow;
    } finally {
      setState(() {
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorStyle>(
      builder: (_, style, __) => Form(
        key: _formKey,
        child: FocusTraversalGroup(
          child: Container(
            padding: EdgeInsets.all(32).copyWith(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 16),
                  child: SelectableText(
                    widget.title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      color: style.formColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      buildFormItem(context.i18.applicationManagerAppName,
                          hintText: ' example:  autoApp_ios_iphone12 (require)',
                          initialValue: widget.initialName,
                          focusNode: focusNode,
                          onSaved: (v) => _name = v),
                      Divider(height: 1, thickness: 1.5),
                      buildFormItem(context.i18.applicationManagerHost,
                          hintText: ' example:  127.0.0.1 (require)',
                          initialValue: widget.initialHost,
                          onSaved: (v) => _host = v),
                      Divider(height: 1, thickness: 1.5),
                      buildFormItem(context.i18.applicationManagerPort,
                          hintText: ' example:  7001 (require)',
                          initialValue: widget?.initialPort?.toString(),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onSaved: (v) => _port = int.tryParse(v) ?? _port),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      buildButton(
                          style: style,
                          text: context.i18.ok,
                          primary: true,
                          onPressed: confirm),
                      buildButton(
                          style: style,
                          text: context.i18.cancel,
                          primary: false,
                          onPressed: cancel),
                      buildButton(
                          style: style,
                          text: context.i18.applicationManagerCheckConnection,
                          primary: false,
                          onPressed: _checking ? null : check),
                      if (_checking)
                        Container(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation(style.indicatorColor),
                          ),
                        )
                    ],
                  ),
                ),
                if (_appInfo != null) AppInfoPanel(_appInfo)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
