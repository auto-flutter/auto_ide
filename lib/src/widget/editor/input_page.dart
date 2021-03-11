import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/provider/style.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../focus_builder.dart';
import 'editor.dart';

enum InputType {
  //todo
  string
}

class FormItem {
  final String title;
  final String hint;
  final InputType type;
  final String key;
  final String initialValue;
  final bool require;

  FormItem(
      {@required this.title,
      @required this.key,
      this.require = false,
      this.hint,
      this.initialValue,
      this.type = InputType.string});
}

class InputPage extends StatefulWidget {
  final String title;
  final List<FormItem> formItemGroup;
  final InFunc<Map<String, String>> onSave;
  final ViewKey viewKey;

  InputPage(
      {Key key,
      @required this.title,
      @required this.formItemGroup,
      @required this.viewKey,
      @required this.onSave})
      : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  final Map<String, String> result = <String, String>{};

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
      FormFieldSetter<String> onSaved,
      FocusNode focusNode,
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
            child: TextFormField(
          onSaved: onSaved,
          focusNode: focusNode,
          initialValue: initialValue,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
          ),
        )),
      ],
    );
  }

  Widget buildButton(
      {@required String text,
      @required VoidCallback onPressed,
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

    Iterable<FormItem> requireKeys =
        widget.formItemGroup.where((element) => element.require);

    for (var item in requireKeys) {
      if (result[item.key]?.isNotEmpty != true) {
        return ToastUtil.emptyError(item.title);
      }
    }

    widget.onSave?.call(result);
    context.read<EditorController>().close(widget.viewKey);
  }

  void cancel() {
    context.read<EditorController>().close(widget.viewKey);
  }

  List<Widget> buildForm() {
    if (widget.formItemGroup.isEmpty) {
      return [];
    }
    List<Widget> children = <Widget>[];
    void add(FormItem item, {FocusNode focusNode}) {
      children.add(buildFormItem(item.title,
          focusNode: focusNode,
          hintText: item.hint,
          initialValue: item.initialValue, onSaved: (v) {
        result[item.key] = v;
      }));
    }

    Iterator<FormItem> iterator = widget.formItemGroup.iterator;
    iterator.moveNext();
    add(iterator.current, focusNode: focusNode);

    while (iterator.moveNext()) {
      children.add(Divider(height: 1, thickness: 1.5));
      add(iterator.current);
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<EditorStyle>();
    return Form(
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
                  children: buildForm(),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
