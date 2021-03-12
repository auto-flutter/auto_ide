// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `File Manager`
  String get toolbarFileManagerTip {
    return Intl.message(
      'File Manager',
      name: 'toolbarFileManagerTip',
      desc: '',
      args: [],
    );
  }

  /// `Application Manager`
  String get toolbarApplicationManagerTip {
    return Intl.message(
      'Application Manager',
      name: 'toolbarApplicationManagerTip',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get toolbarSettingsTip {
    return Intl.message(
      'Settings',
      name: 'toolbarSettingsTip',
      desc: '',
      args: [],
    );
  }

  /// `System Log`
  String get toolbarSystemLogTip {
    return Intl.message(
      'System Log',
      name: 'toolbarSystemLogTip',
      desc: '',
      args: [],
    );
  }

  /// `Application Manager`
  String get applicationManagerTitle {
    return Intl.message(
      'Application Manager',
      name: 'applicationManagerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add Application`
  String get applicationManagerAddTip {
    return Intl.message(
      'Add Application',
      name: 'applicationManagerAddTip',
      desc: '',
      args: [],
    );
  }

  /// `Refresh All Application`
  String get applicationManagerRefreshAllTip {
    return Intl.message(
      'Refresh All Application',
      name: 'applicationManagerRefreshAllTip',
      desc: '',
      args: [],
    );
  }

  /// `Application (Add) `
  String get applicationManagerAddTab {
    return Intl.message(
      'Application (Add) ',
      name: 'applicationManagerAddTab',
      desc: '',
      args: [],
    );
  }

  /// `Add Application`
  String get applicationManagerAddPageTitle {
    return Intl.message(
      'Add Application',
      name: 'applicationManagerAddPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Application`
  String get applicationManagerEditPageTitle {
    return Intl.message(
      'Edit Application',
      name: 'applicationManagerEditPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `App Name`
  String get applicationManagerAppName {
    return Intl.message(
      'App Name',
      name: 'applicationManagerAppName',
      desc: '',
      args: [],
    );
  }

  /// `Host`
  String get applicationManagerHost {
    return Intl.message(
      'Host',
      name: 'applicationManagerHost',
      desc: '',
      args: [],
    );
  }

  /// `Port`
  String get applicationManagerPort {
    return Intl.message(
      'Port',
      name: 'applicationManagerPort',
      desc: '',
      args: [],
    );
  }

  /// `Check Connection`
  String get applicationManagerCheckConnection {
    return Intl.message(
      'Check Connection',
      name: 'applicationManagerCheckConnection',
      desc: '',
      args: [],
    );
  }

  /// `New Auto File`
  String get fileManagerNewAutoFile {
    return Intl.message(
      'New Auto File',
      name: 'fileManagerNewAutoFile',
      desc: '',
      args: [],
    );
  }

  /// `File Name`
  String get fileManagerNewFormFileName {
    return Intl.message(
      'File Name',
      name: 'fileManagerNewFormFileName',
      desc: '',
      args: [],
    );
  }

  /// `Right-click the folder to create a new auto file`
  String get fileManagerNewAutoFileTip {
    return Intl.message(
      'Right-click the folder to create a new auto file',
      name: 'fileManagerNewAutoFileTip',
      desc: '',
      args: [],
    );
  }

  /// `System Log`
  String get systemLogTab {
    return Intl.message(
      'System Log',
      name: 'systemLogTab',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTab {
    return Intl.message(
      'Settings',
      name: 'settingsTab',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settingsLanguage {
    return Intl.message(
      'Language',
      name: 'settingsLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Custom 'auto_util' Path`
  String get settingsAutoUtil {
    return Intl.message(
      'Custom `auto_util` Path',
      name: 'settingsAutoUtil',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get editorTabClose {
    return Intl.message(
      'Close',
      name: 'editorTabClose',
      desc: '',
      args: [],
    );
  }

  /// `Close other`
  String get editorTabCloseOther {
    return Intl.message(
      'Close other',
      name: 'editorTabCloseOther',
      desc: '',
      args: [],
    );
  }

  /// `Close all`
  String get editorTabCloseAll {
    return Intl.message(
      'Close all',
      name: 'editorTabCloseAll',
      desc: '',
      args: [],
    );
  }

  /// `Close all to the left `
  String get editorTabCloseLeft {
    return Intl.message(
      'Close all to the left ',
      name: 'editorTabCloseLeft',
      desc: '',
      args: [],
    );
  }

  /// `Close all to the right `
  String get editorTabCloseRight {
    return Intl.message(
      'Close all to the right ',
      name: 'editorTabCloseRight',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Redo`
  String get redo {
    return Intl.message(
      'Redo',
      name: 'redo',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message(
      'Undo',
      name: 'undo',
      desc: '',
      args: [],
    );
  }

  /// `Zoom In`
  String get zoomIn {
    return Intl.message(
      'Zoom In',
      name: 'zoomIn',
      desc: '',
      args: [],
    );
  }

  /// `Zoom Out`
  String get zoomOut {
    return Intl.message(
      'Zoom Out',
      name: 'zoomOut',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get zoomReset {
    return Intl.message(
      'Reset',
      name: 'zoomReset',
      desc: '',
      args: [],
    );
  }

  /// `Width`
  String get width {
    return Intl.message(
      'Width',
      name: 'width',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get height {
    return Intl.message(
      'Height',
      name: 'height',
      desc: '',
      args: [],
    );
  }

  /// `Resolution`
  String get resolution {
    return Intl.message(
      'Resolution',
      name: 'resolution',
      desc: '',
      args: [],
    );
  }

  /// `OPEN`
  String get open {
    return Intl.message(
      'OPEN',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `View details`
  String get viewDetails {
    return Intl.message(
      'View details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `{arg} parameter must not be null`
  String toastRequireNonNull(Object arg) {
    return Intl.message(
      '$arg parameter must not be null',
      name: 'toastRequireNonNull',
      desc: '',
      args: [arg],
    );
  }

  /// `{arg} parameter must not be empty`
  String toastRequireNonEmpty(Object arg) {
    return Intl.message(
      '$arg parameter must not be empty',
      name: 'toastRequireNonEmpty',
      desc: '',
      args: [arg],
    );
  }

  /// `Platform`
  String get appInfoPanelPlatform {
    return Intl.message(
      'Platform',
      name: 'appInfoPanelPlatform',
      desc: '',
      args: [],
    );
  }

  /// `Mode`
  String get appInfoPanelMode {
    return Intl.message(
      'Mode',
      name: 'appInfoPanelMode',
      desc: '',
      args: [],
    );
  }

  /// `Device Name`
  String get appInfoPanelDeviceName {
    return Intl.message(
      'Device Name',
      name: 'appInfoPanelDeviceName',
      desc: '',
      args: [],
    );
  }

  /// `Api Version`
  String get appInfoPanelApiVersion {
    return Intl.message(
      'Api Version',
      name: 'appInfoPanelApiVersion',
      desc: '',
      args: [],
    );
  }

  /// `File format is not supported`
  String get unsupportedPageTitle {
    return Intl.message(
      'File format is not supported',
      name: 'unsupportedPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get autoPageStartTip {
    return Intl.message(
      'Start',
      name: 'autoPageStartTip',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get autoPagePauseTip {
    return Intl.message(
      'Pause',
      name: 'autoPagePauseTip',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get autoPageContinueTip {
    return Intl.message(
      'Continue',
      name: 'autoPageContinueTip',
      desc: '',
      args: [],
    );
  }

  /// `Stop recording and save`
  String get autoPageStopSaveTip {
    return Intl.message(
      'Stop recording and save',
      name: 'autoPageStopSaveTip',
      desc: '',
      args: [],
    );
  }

  /// `Stop recording`
  String get autoPageStopTip {
    return Intl.message(
      'Stop recording',
      name: 'autoPageStopTip',
      desc: '',
      args: [],
    );
  }

  /// `Replay`
  String get autoPageReplayTip {
    return Intl.message(
      'Replay',
      name: 'autoPageReplayTip',
      desc: '',
      args: [],
    );
  }

  /// `Prohibit keyboard pop-up during recording`
  String get autoPageDisableKeyboardTip {
    return Intl.message(
      'Prohibit keyboard pop-up during recording',
      name: 'autoPageDisableKeyboardTip',
      desc: '',
      args: [],
    );
  }

  /// `Add checkpoint`
  String get autoPageAddCheckpointTip {
    return Intl.message(
      'Add checkpoint',
      name: 'autoPageAddCheckpointTip',
      desc: '',
      args: [],
    );
  }

  /// `Add delay (Right-click to select delay),this delay will take effect during playback`
  String get autoPageAddDelayTip {
    return Intl.message(
      'Add delay (Right-click to select delay),this delay will take effect during playback',
      name: 'autoPageAddDelayTip',
      desc: '',
      args: [],
    );
  }

  /// `Dependencies will be automatically pre-executed (It is recommended to split the test case into multiple jump dependencies and an Auto file containing the main test logic)`
  String get autoPageDependenciesTip {
    return Intl.message(
      'Dependencies will be automatically pre-executed (It is recommended to split the test case into multiple jump dependencies and an Auto file containing the main test logic)',
      name: 'autoPageDependenciesTip',
      desc: '',
      args: [],
    );
  }

  /// `Check points are some pictures that need to be matched (you need to circle the key places on the picture)`
  String get autoPageCheckpointsTip {
    return Intl.message(
      'Check points are some pictures that need to be matched (you need to circle the key places on the picture)',
      name: 'autoPageCheckpointsTip',
      desc: '',
      args: [],
    );
  }

  /// `Select App`
  String get autoPageSelectApp {
    return Intl.message(
      'Select App',
      name: 'autoPageSelectApp',
      desc: '',
      args: [],
    );
  }

  /// `Config App`
  String get autoPageConfigApp {
    return Intl.message(
      'Config App',
      name: 'autoPageConfigApp',
      desc: '',
      args: [],
    );
  }

  /// `Delay: {arg}`
  String autoPageDelayToastTitle(Object arg) {
    return Intl.message(
      'Delay: $arg',
      name: 'autoPageDelayToastTitle',
      desc: '',
      args: [arg],
    );
  }

  /// `You can change the running order of dependencies by dragging`
  String get autoPageDependenciesOrderHint {
    return Intl.message(
      'You can change the running order of dependencies by dragging',
      name: 'autoPageDependenciesOrderHint',
      desc: '',
      args: [],
    );
  }

  /// `Add dependencies by dragging and dropping auto files`
  String get autoPageDependenciesHint {
    return Intl.message(
      'Add dependencies by dragging and dropping auto files',
      name: 'autoPageDependenciesHint',
      desc: '',
      args: [],
    );
  }

  /// `Dependencies`
  String get autoPageDependenciesTitle {
    return Intl.message(
      'Dependencies',
      name: 'autoPageDependenciesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Checkpoints`
  String get autoPageCheckpointsTitle {
    return Intl.message(
      'Checkpoints',
      name: 'autoPageCheckpointsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Match test passed!`
  String get autoPageMatchTestPassed {
    return Intl.message(
      'Match test passed!',
      name: 'autoPageMatchTestPassed',
      desc: '',
      args: [],
    );
  }

  /// `Match test failed!`
  String get autoPageMatchTestFailed {
    return Intl.message(
      'Match test failed!',
      name: 'autoPageMatchTestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Open remote input`
  String get autoPageOpenRemoteInput {
    return Intl.message(
      'Open remote input',
      name: 'autoPageOpenRemoteInput',
      desc: '',
      args: [],
    );
  }

  /// ` <Enter> to send`
  String get autoPageRemoteInputHint {
    return Intl.message(
      ' <Enter> to send',
      name: 'autoPageRemoteInputHint',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get reportPageTab {
    return Intl.message(
      'Report',
      name: 'reportPageTab',
      desc: '',
      args: [],
    );
  }

  /// `SUCCESS`
  String get reportPageSuccessTitle {
    return Intl.message(
      'SUCCESS',
      name: 'reportPageSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `FAILURE`
  String get reportPageFailureTitle {
    return Intl.message(
      'FAILURE',
      name: 'reportPageFailureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Log`
  String get reportPageLogTitle {
    return Intl.message(
      'Log',
      name: 'reportPageLogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Checkpoint`
  String get reportPageCheckpointTitle {
    return Intl.message(
      'Checkpoint',
      name: 'reportPageCheckpointTitle',
      desc: '',
      args: [],
    );
  }

  /// `Reason: {arg}`
  String reportPageErrorReason(Object arg) {
    return Intl.message(
      'Reason: $arg',
      name: 'reportPageErrorReason',
      desc: '',
      args: [arg],
    );
  }

  /// `Original application information:`
  String get reportPageOriginalAppTitle {
    return Intl.message(
      'Original application information:',
      name: 'reportPageOriginalAppTitle',
      desc: '',
      args: [],
    );
  }

  /// `Test application information:`
  String get reportPageTestAppTitle {
    return Intl.message(
      'Test application information:',
      name: 'reportPageTestAppTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}