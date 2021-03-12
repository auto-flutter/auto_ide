part of 'auto_page.dart';

final Logger _log = Logger('AutoPlayer');

enum Status {
  idle,
  started,
  paused,
  replaying,
  replayPaused,
  completed,
}

class AutoPlayer extends ChangeNotifier {
  AutoPlayer({AutoScript initialScript, @required this.savePath}) {
    if (initialScript == null || initialScript.record.isEmpty) {
      _status = Status.idle;
    } else {
      _status = Status.completed;
    }
    this._script = initialScript;
  }

  final String savePath;
  RemoteApp _remoteApp;
  Status _status;
  AutoScript _script;

  Status get status => _status;

  bool get isIdle => _status == Status.idle;

  bool get isStarted => _status == Status.started;

  bool get isPaused => _status == Status.paused;

  bool get isReplaying => _status == Status.replaying;

  bool get isReplayPaused => _status == Status.replayPaused;

  bool get isCompleted => _status == Status.completed;

  bool get hasRemoteApp => _remoteApp != null;

  bool get autoScriptAvailable => _script != null && _script.record.isNotEmpty;

  Future<void> start({bool force = false,bool disableKeyboard = false}) async {
    if ((isIdle || isCompleted) && hasRemoteApp) {
      final result = await _remoteApp.start(force: force,disableKeyboard: disableKeyboard);
      if (result.ok) {
        _setStatus(Status.started);
      } else {
        _log.severe(result.error);
        ToastUtil.error(result.error.toString());
      }
    }
  }

  Future<void> stop() async {
    if ((isStarted || isPaused) && hasRemoteApp) {
      final result = await _remoteApp.stop(dependencies());
      if (result.ok) {
        if (autoScriptAvailable) {
          _setStatus(Status.completed);
        } else {
          _setStatus(Status.idle);
        }
      } else {
        _log.severe(result.error);
        ToastUtil.error(result.error.toString());
      }
    }
  }

  Future<void> stopAndSave() async {
    if ((isStarted || isPaused) && hasRemoteApp) {
      final result = await _remoteApp.stop(dependencies());
      if (result.ok) {
        _script = result.result;
        await save();
        _setStatus(Status.completed);
      } else {
        _log.severe(result.error);
        ToastUtil.error(result.error.toString());
      }
    }
  }

  Future<void> pause() async {
    if (isStarted && hasRemoteApp) {
      final result = await _remoteApp.pause();
      if (result.ok) {
        _setStatus(Status.paused);
      } else {
        _log.severe(result.error);
        ToastUtil.error(result.error.toString());
      }
    }
  }

  Future<void> continue1() async {
    if (isPaused && hasRemoteApp) {
      final result = await _remoteApp.continue1();
      if (result.ok) {
        _setStatus(Status.started);
      } else {
        _log.severe(result.error);
        ToastUtil.error(result.error.toString());
      }
    }
  }

  Future<void> addCheckpoint() async {
    if ((isStarted || isPaused) && hasRemoteApp) {
      final result = await _remoteApp.addCheckpoint();
      if (!result.ok) {
        _log.severe(result.error);
        ToastUtil.error(result.error.toString());
      }
    }
  }

  Future<void> addDelay(Duration delay) async {
    if ((isStarted || isPaused) && hasRemoteApp) {
      final result = await _remoteApp.addDelay(delay);
      if (!result.ok) {
        _log.severe(result.error);
        ToastUtil.error(result.error.toString());
      }
    }
  }

  Future<void> enterText(String text) async {
    if ((isStarted || isPaused) && hasRemoteApp) {
      final result = await _remoteApp.enterText(text);
      if (!result.ok) {
        _log.severe(result.error);
        ToastUtil.error(result.error.toString());
      }
    }
  }

  Future<PlaybackReport> replay({ bool force = false,@required String autoUtilPath}) async {
    if (isCompleted && hasRemoteApp) {
      assert(autoScriptAvailable);
      _setStatus(Status.replaying);
      try {
        final result = await _remoteApp.replayWithTarFile(savePath,
            force: force,
            timeout: Duration(
                minutes: 1, microseconds: _script.metaData.totalTime.toInt()));
        if (!result.ok) {
          throw Exception('BadRequestResponse: ${result.error}');
        }
        if (!await CommandUtil.checkCommandIsExist(autoUtilPath)) {
          _log.warning('PATH: ${Platform.environment['PATH']}');
          throw Exception('Command $autoUtilPath not found!');
        }

        return MatchUtil.match(_script, result.result, threshold: 0.8);
      } finally {
        _setStatus(Status.completed);
      }
    }else{
      throw StateError(status.toString());
    }
  }

  Future<void> stopReplay() async {
    if (isReplaying && hasRemoteApp) {
      final result = await _remoteApp.stopReplay();
      if (result.ok) {
        assert(autoScriptAvailable);
        _setStatus(Status.completed);
      } else {
        _log.severe(result.error);
        ToastUtil.error(result.error.toString());
      }
    }
  }

  Future<void> addMatchPosition(String name, RatioRect ratioRect) async {
    int index =
        _script.checkpoints.indexWhere((element) => element.name == name);
    if (index == -1) {
      return;
    }
    _script.checkpoints[index].matchPositions.add(ratioRect);
    notifyListeners();
    return save();
  }

  Future<void> removeMatchPosition(String name, RatioRect ratioRect) async {
    int index =
        _script.checkpoints.indexWhere((element) => element.name == name);
    if (index == -1) {
      return;
    }
    _script.checkpoints[index].matchPositions.remove(ratioRect);
    notifyListeners();
    return save();
  }

  Future<void> removeAllMatchPosition() async {
    _script.checkpoints.forEach((element) {
      element.matchPositions.clear();
    });
    notifyListeners();
    return save();
  }

  List<Checkpoint> checkpoints() {
    return _script?.checkpoints ?? [];
  }

  Future<void> save() async {
    await _script.save(savePath);
  }

  Future<void> close() async {
    if (isStarted) {
      await stop();
    } else if (isReplaying) {
      await stopReplay();
    }
    dispose();
  }

  Future<void> addDependency(String dependency) async {
    _script.dependencies.add(dependency);
    notifyListeners();
    return save();
  }

  Future<void> removeDependencyAt(int index) async {
    _script.dependencies.removeAt(index);
    notifyListeners();
    return save();
  }

  List<String> dependencies() {
    return _script?.dependencies ?? [];
  }

  Future<void> reorderDependencies(int oldIndex, int newIndex) {
    final dependencies = _script.dependencies;
    if ((oldIndex - newIndex).abs() == 1) {
      final old = dependencies[oldIndex];
      dependencies[oldIndex] = dependencies[newIndex];
      dependencies[newIndex] = old;
    } else {
      final item = dependencies.removeAt(oldIndex);
      if (oldIndex < newIndex) {
        newIndex--;
      }
      dependencies.insert(newIndex, item);
    }
    notifyListeners();
    return save();
  }

  void attach(RemoteApp remoteApp) {
    assert(isIdle || isCompleted);
    _remoteApp = remoteApp;
    notifyListeners();
  }

  void detach() {
    assert(isIdle || isCompleted);
    _remoteApp = null;
    notifyListeners();
  }

  void _setStatus(Status newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}
