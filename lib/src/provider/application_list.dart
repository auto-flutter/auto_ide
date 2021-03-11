import 'dart:typed_data';

import 'package:auto_core/auto_core.dart';
import 'package:auto_ide/protos/application.pbserver.dart';
import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/storage/kv_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationConfig {
  final Application application;
  bool online;

  ApplicationConfig(this.application, {this.online = false});
}

abstract class ApplicationConfigListController {
  List<ApplicationConfig> get current;

  void add(Application application, {bool online=false});

  void remove(String id);

  void update(Application application,{bool online=false});

  Future<void> refresh(String id);

  Future<void> refreshAll();
}

class ApplicationConfigListProvider extends StatefulWidget {

  final Widget child;

  const ApplicationConfigListProvider({Key key, this.child}) : super(key: key);

  @override
  _ApplicationConfigListProviderState createState() =>
      _ApplicationConfigListProviderState();
}

class _ApplicationConfigListProviderState
    extends State<ApplicationConfigListProvider>
    implements ApplicationConfigListController {

  ApplicationList _applicationList;

  @override
  final List<ApplicationConfig> current = <ApplicationConfig>[];

  bool _needNoticeUpdate = false;

  static const String _key = 'applicationList';

  @override
  void initState() {
    super.initState();
    final storage = context.read<KVStorage>();
    final bytes =
    storage.get<Uint8List>(_key, namespace: Namespace.applicationManager);
    _applicationList = ApplicationList.fromBuffer(bytes ?? []);
    _applicationList.list.forEach((element) {
      current.add(ApplicationConfig(element));
    });

    refreshAll();
  }

  @override
  void add(Application application, {bool online=false}) {
    current.add(ApplicationConfig(application, online: online));
    _applicationList.list.add(application);
    _save();
    markNeedUpdate();
  }

  @override
  Future<void> refresh(String id) async {
    final index = current.indexWhere((element) => element.application.id == id);
    if (index != -1) {
      final item = current[index];
      final appConfig = item.application;
      final remoteApp = RemoteApp(host: appConfig.host, port: appConfig.port);
      final ok = await remoteApp.ping();
      item.online = ok;
      markNeedUpdate();
    }
  }

  @override
  Future<void> refreshAll() async {
    await Future.wait(current.map((e) async {
      final appConfig = e.application;
      final remoteApp = RemoteApp(host: appConfig.host, port: appConfig.port);
      final ok = await remoteApp.ping();
      e.online = ok;
    }));
    markNeedUpdate();
  }

  @override
  void update(Application application,{bool online=false}) {
    final index = current.indexWhere((element) => element.application.id == application.id);
    if (index != -1) {
      assert(current[index].application.id==_applicationList.list[index].id);

      current[index].application.name = application.name;
      current[index].application.host = application.host;
      current[index].application.port = application.port;
      current[index].application.id = application.id;
      current[index].online = online;
      _applicationList.list[index] = application;

      _save();
      markNeedUpdate();
    }
  }

  @override
  void remove(String id) {
    current.removeWhere((element) => element.application.id == id);
    _applicationList.list.removeWhere((element) => element.id == id);
    _save();
    markNeedUpdate();
  }

  void _save(){
    final storage = context.read<KVStorage>();
    storage.set(_key,_applicationList.writeToBuffer(),namespace: Namespace.applicationManager);
  }

  void markNeedUpdate() {
    if (mounted) {
      setState(() {
        _needNoticeUpdate = true;
      });
    }
  }

  bool updateShouldNotify(ApplicationConfigListController previous,
      ApplicationConfigListController current) {
    final result = _needNoticeUpdate;
    _needNoticeUpdate = false;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ApplicationConfigListController>.value(
      value: this,
      updateShouldNotify: updateShouldNotify,
      child: widget.child,
    );
  }


}
