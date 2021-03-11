// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(arg) => "Delay: ${arg}";

  static m1(arg) => "Reason: ${arg}";

  static m2(arg) => "${arg} parameter must not be empty";

  static m3(arg) => "${arg} parameter must not be null";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appInfoPanelApiVersion" : MessageLookupByLibrary.simpleMessage("Api Version"),
    "appInfoPanelDeviceName" : MessageLookupByLibrary.simpleMessage("Device Name"),
    "appInfoPanelMode" : MessageLookupByLibrary.simpleMessage("Mode"),
    "appInfoPanelPlatform" : MessageLookupByLibrary.simpleMessage("Platform"),
    "applicationManagerAddPageTitle" : MessageLookupByLibrary.simpleMessage("Add Application"),
    "applicationManagerAddTab" : MessageLookupByLibrary.simpleMessage("Application (Add) "),
    "applicationManagerAddTip" : MessageLookupByLibrary.simpleMessage("Add Application"),
    "applicationManagerAppName" : MessageLookupByLibrary.simpleMessage("App Name"),
    "applicationManagerCheckConnection" : MessageLookupByLibrary.simpleMessage("Check Connection"),
    "applicationManagerEditPageTitle" : MessageLookupByLibrary.simpleMessage("Edit Application"),
    "applicationManagerHost" : MessageLookupByLibrary.simpleMessage("Host"),
    "applicationManagerPort" : MessageLookupByLibrary.simpleMessage("Port"),
    "applicationManagerRefreshAllTip" : MessageLookupByLibrary.simpleMessage("Refresh All Application"),
    "applicationManagerTitle" : MessageLookupByLibrary.simpleMessage("Application Manager"),
    "autoPageAddCheckpointTip" : MessageLookupByLibrary.simpleMessage("Add checkpoint"),
    "autoPageAddDelayTip" : MessageLookupByLibrary.simpleMessage("Add delay (Right-click to select delay)"),
    "autoPageCheckpointsTip" : MessageLookupByLibrary.simpleMessage("Check points are some pictures that need to be matched (you need to circle the key places on the picture)"),
    "autoPageCheckpointsTitle" : MessageLookupByLibrary.simpleMessage("Checkpoints"),
    "autoPageConfigApp" : MessageLookupByLibrary.simpleMessage("Config App"),
    "autoPageContinueTip" : MessageLookupByLibrary.simpleMessage("Continue"),
    "autoPageDelayToastTitle" : m0,
    "autoPageDependenciesHint" : MessageLookupByLibrary.simpleMessage("Add dependencies by dragging and dropping auto files"),
    "autoPageDependenciesOrderHint" : MessageLookupByLibrary.simpleMessage("You can change the running order of dependencies by dragging"),
    "autoPageDependenciesTip" : MessageLookupByLibrary.simpleMessage("Dependencies will be automatically pre-executed"),
    "autoPageDependenciesTitle" : MessageLookupByLibrary.simpleMessage("Dependencies"),
    "autoPageDisableKeyboardTip" : MessageLookupByLibrary.simpleMessage("Prohibit keyboard pop-up during recording"),
    "autoPageMatchTestFailed" : MessageLookupByLibrary.simpleMessage("Match test failed!"),
    "autoPageMatchTestPassed" : MessageLookupByLibrary.simpleMessage("Match test passed!"),
    "autoPageOpenRemoteInput" : MessageLookupByLibrary.simpleMessage("Open remote input"),
    "autoPagePauseTip" : MessageLookupByLibrary.simpleMessage("Pause"),
    "autoPageRemoteInputHint" : MessageLookupByLibrary.simpleMessage(" <Enter> to send"),
    "autoPageReplayTip" : MessageLookupByLibrary.simpleMessage("Replay"),
    "autoPageSelectApp" : MessageLookupByLibrary.simpleMessage("Select App"),
    "autoPageStartTip" : MessageLookupByLibrary.simpleMessage("Start"),
    "autoPageStopSaveTip" : MessageLookupByLibrary.simpleMessage("Stop recording and save"),
    "autoPageStopTip" : MessageLookupByLibrary.simpleMessage("Stop recording"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "delete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "editorTabClose" : MessageLookupByLibrary.simpleMessage("Close"),
    "editorTabCloseAll" : MessageLookupByLibrary.simpleMessage("Close all"),
    "editorTabCloseLeft" : MessageLookupByLibrary.simpleMessage("Close all to the left "),
    "editorTabCloseOther" : MessageLookupByLibrary.simpleMessage("Close other"),
    "editorTabCloseRight" : MessageLookupByLibrary.simpleMessage("Close all to the right "),
    "fileManagerNewAutoFile" : MessageLookupByLibrary.simpleMessage("New Auto File"),
    "fileManagerNewAutoFileTip" : MessageLookupByLibrary.simpleMessage("Right-click the folder to create a new auto file"),
    "fileManagerNewFormFileName" : MessageLookupByLibrary.simpleMessage("File Name"),
    "height" : MessageLookupByLibrary.simpleMessage("Height"),
    "ok" : MessageLookupByLibrary.simpleMessage("Ok"),
    "open" : MessageLookupByLibrary.simpleMessage("OPEN"),
    "redo" : MessageLookupByLibrary.simpleMessage("Redo"),
    "refresh" : MessageLookupByLibrary.simpleMessage("Refresh"),
    "reportPageCheckpointTitle" : MessageLookupByLibrary.simpleMessage("Checkpoint"),
    "reportPageErrorReason" : m1,
    "reportPageFailureTitle" : MessageLookupByLibrary.simpleMessage("FAILURE"),
    "reportPageLogTitle" : MessageLookupByLibrary.simpleMessage("Log"),
    "reportPageOriginalAppTitle" : MessageLookupByLibrary.simpleMessage("Original application information:"),
    "reportPageSuccessTitle" : MessageLookupByLibrary.simpleMessage("SUCCESS"),
    "reportPageTab" : MessageLookupByLibrary.simpleMessage("Report"),
    "reportPageTestAppTitle" : MessageLookupByLibrary.simpleMessage("Test application information:"),
    "resolution" : MessageLookupByLibrary.simpleMessage("Resolution"),
    "save" : MessageLookupByLibrary.simpleMessage("Save"),
    "select" : MessageLookupByLibrary.simpleMessage("Select"),
    "settingsAutoUtil" : MessageLookupByLibrary.simpleMessage("Custom `auto_util` Path"),
    "settingsLanguage" : MessageLookupByLibrary.simpleMessage("Language"),
    "settingsTab" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsTitle" : MessageLookupByLibrary.simpleMessage("Settings"),
    "systemLogTab" : MessageLookupByLibrary.simpleMessage("System Log"),
    "toastRequireNonEmpty" : m2,
    "toastRequireNonNull" : m3,
    "toolbarApplicationManagerTip" : MessageLookupByLibrary.simpleMessage("Application Manager"),
    "toolbarFileManagerTip" : MessageLookupByLibrary.simpleMessage("File Manager"),
    "toolbarSettingsTip" : MessageLookupByLibrary.simpleMessage("Settings"),
    "toolbarSystemLogTip" : MessageLookupByLibrary.simpleMessage("System Log"),
    "undo" : MessageLookupByLibrary.simpleMessage("Undo"),
    "unsupportedPageTitle" : MessageLookupByLibrary.simpleMessage("File format is not supported"),
    "viewDetails" : MessageLookupByLibrary.simpleMessage("View details"),
    "width" : MessageLookupByLibrary.simpleMessage("Width"),
    "zoomIn" : MessageLookupByLibrary.simpleMessage("Zoom In"),
    "zoomOut" : MessageLookupByLibrary.simpleMessage("Zoom Out"),
    "zoomReset" : MessageLookupByLibrary.simpleMessage("Reset")
  };
}
