import 'package:auto_ide/src/provider/provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:auto_ide/src/common/common.dart';

import 'editor.dart';

class SettingsPage extends StatefulWidget {
  final ViewKey viewKey;

  const SettingsPage({Key key, @required this.viewKey}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  TextEditingController controller;

  @override
  void initState(){
    super.initState();
    String customAutoUtil=context.read<SettingsController>().get(SettingKey.autoUtil);
    controller=TextEditingController(text: customAutoUtil);

  }

  Map<String, Object> newSettings = <String, Object>{};

  void confirm() {
    context.read<SettingsController>().apply(newSettings);
    context.read<EditorController>().close(widget.viewKey);
  }

  void cancel() {
    context.read<EditorController>().close(widget.viewKey);
  }

  Widget buildButton(
      {@required String text,
      @required VoidCallback onPressed,
      @required EditorStyle style,
      double borderRadius = 4,
        EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      bool primary = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
            backgroundColor: MaterialStateProperty.all(primary
                ? style.primaryButtonColor
                : style.secondaryButtonColor)),
        child: Padding(
          padding: padding,
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editorStyle = context.watch<EditorStyle>();

    String language = newSettings[SettingKey.language] ??
        Localizations.localeOf(context).toString();

    return Container(
      padding: EdgeInsets.all(40).copyWith(top: 24),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: SelectableText(
              context.i18.settingsTitle,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 24),
            child: SelectableText(
              context.i18.settingsLanguage,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Container(
            color: editorStyle.formColor,
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(8),
            constraints: BoxConstraints(minWidth: 300),
            height: 40,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                onChanged: (v) {
                  setState(() {
                    newSettings[SettingKey.language] = v;
                  });
                },
                style: TextStyle(fontSize: 14),
                icon: Icon(Icons.expand_more),
                iconSize: 16,
                value: language,
                items: [
                  DropdownMenuItem(
                    child: Text('English', style: TextStyle(fontSize: 14)),
                    value: 'en',
                  ),
                  DropdownMenuItem(
                    child: Text('简体中文', style: TextStyle(fontSize: 14)),
                    value: 'zh',
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 24),
            child: SelectableText(
              context.i18.settingsAutoUtil,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: editorStyle.formColor,
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.symmetric(vertical: 6,horizontal: 8),
                    child: TextField(
                      controller: controller,
                      onChanged: (path){
                        newSettings[SettingKey.autoUtil] = path;
                      },
                      style: Theme.of(context).textTheme.subtitle2,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                buildButton(
                    style: editorStyle,
                    text: context.i18.select,
                    primary: true,
                    borderRadius: 2,
                    padding: EdgeInsets.all(8),
                    onPressed: () async {
                      final xfile = await openFile();
                      if (xfile == null) {
                        return;
                      }
                      newSettings[SettingKey.autoUtil] = xfile.path;
                      controller.text=xfile.path;
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Row(
              children: [
                buildButton(
                    style: editorStyle,
                    text: context.i18.ok,
                    primary: true,
                    onPressed: confirm),
                buildButton(
                    style: editorStyle,
                    text: context.i18.cancel,
                    primary: false,
                    onPressed: cancel),
              ],
            ),
          )
        ],
      ),
    );
  }
}
