import 'dart:async';
import 'dart:io';

import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:auto_ide/src/welcome_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'generated/l10n.dart';
import 'src/provider/style.dart';
import 'package:path_provider/path_provider.dart';

import 'src/storage/file_kv_storage.dart';
import 'src/storage/kv_storage.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';

void onError() {}

final Logger _log = Logger.root;
final Logger _flutterLog = Logger('Flutter framework');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final path = await getApplicationDocumentsDirectory();
  final finalPath = join(path.path, 'Auto', 'KVData');
  if (!File(finalPath).existsSync()) {
    File(finalPath).createSync(recursive: true);
  }
  final storage = FileStorage(finalPath);
  await storage.load();

  setWindowMinSize(Size(1080, 500));

  // ignore: close_sinks
  final streamController = StreamController<String>.broadcast();
  final logCollector= LogCollector(streamController.stream);


  Logger.root.onRecord.listen((record) {
    print('[${record.level.name}] ${record.loggerName} ${record.time}: ${record.message}');
    if(record.error!=null){
      print(record.error);
    }
    if(record.stackTrace!=null){
      print(record.stackTrace);
    }
    streamController.add('[${record.level.name}] ${record.loggerName} ${record.time}: ${record.message}');
    if (record.error != null) {
      record.error.toString().split('\n').forEach((text) {
        streamController.add(text);
      });
    }
    if (record.stackTrace != null) {
      record.stackTrace.toString().split('\n').forEach((text) {
        streamController.add(text);
      });
    }
  });

  FlutterError.onError = (FlutterErrorDetails details) {
    _flutterLog.severe('', details.exception, details.stack);
  };

  runZonedGuarded(() {
    runApp(_Provider(
      storage: storage,
      logCollector: logCollector,
      child: MyApp(),
    ));
  }, (e, s) {
    _log.severe('Unhandled Exception', e, s);
    ToastUtil.error(e);
  });
}

class _Provider extends StatelessWidget {
  final KVStorage storage;
  final LogCollector logCollector;
  final Widget child;

  const _Provider({Key key, this.child, @required this.storage,@required this.logCollector})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: storage),
        ChangeNotifierProvider.value(value: logCollector),
      ],
      child: SettingsProvider(
        child: ApplicationConfigListProvider(
          child: StyleProvider(
            child: child,
          ),
        ),
      ),
    );
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  IdeStyle style = IdeStyle();

  @override
  Widget build(BuildContext context) {
    final language =
        context.watch<SettingsController>().get<String>(SettingKey.language);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: BotToastInit(),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: language == null ? null : Locale(language),
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
            bodyText1: TextStyle(color: Color(0xd3FFFFFF)),
            bodyText2: TextStyle(color: Color(0xd3FFFFFF))),
      ),
      home: WelcomePage(),
    );
  }
}
