import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/storage/kv_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingKey {
  static const language = 'language';
  static const autoUtil = 'autoUtil';
}

abstract class SettingsController {
  void apply(Map<String, Object> newSettings);

  ///T must be bool,int,double,string,Uint8List
  T get<T>(String key);
}

class SettingsProvider extends StatefulWidget {
  final Widget child;

  const SettingsProvider({Key key, this.child}) : super(key: key);

  @override
  _SettingsProviderState createState() => _SettingsProviderState();
}

class _SettingsProviderState extends State<SettingsProvider>
    implements SettingsController {

  bool needUpdate = false;

  @override
  void apply(Map<String, Object> newSettings) {
    final storage = context.read<KVStorage>();
    newSettings.forEach((key, value) {
      storage.set(key, value,namespace: Namespace.settings);
    });
    setState(() {
      needUpdate=true;
    });
  }

  @override
  T get<T>(String key) {
    final storage = context.read<KVStorage>();
    return storage.get<T>(key,namespace: Namespace.settings);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<SettingsController>.value(
      value: this, child: widget.child, updateShouldNotify: (_, __) {
      final result = needUpdate;
      needUpdate = false;
      return result;
    },);
  }
}
