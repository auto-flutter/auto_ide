// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static m0(arg) => "延迟: ${arg}";

  static m1(arg) => "原因: ${arg}";

  static m2(arg) => "${arg}参数必须不为空";

  static m3(arg) => "${arg}参数必须不为null";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appInfoPanelApiVersion" : MessageLookupByLibrary.simpleMessage("Api版本"),
    "appInfoPanelDeviceName" : MessageLookupByLibrary.simpleMessage("设备名"),
    "appInfoPanelMode" : MessageLookupByLibrary.simpleMessage("模式"),
    "appInfoPanelPlatform" : MessageLookupByLibrary.simpleMessage("平台"),
    "applicationManagerAddPageTitle" : MessageLookupByLibrary.simpleMessage("添加应用"),
    "applicationManagerAddTab" : MessageLookupByLibrary.simpleMessage("添加应用"),
    "applicationManagerAddTip" : MessageLookupByLibrary.simpleMessage("添加应用"),
    "applicationManagerAppName" : MessageLookupByLibrary.simpleMessage("应用名称"),
    "applicationManagerCheckConnection" : MessageLookupByLibrary.simpleMessage("检查连接"),
    "applicationManagerEditPageTitle" : MessageLookupByLibrary.simpleMessage("编辑应用"),
    "applicationManagerHost" : MessageLookupByLibrary.simpleMessage("主机"),
    "applicationManagerPort" : MessageLookupByLibrary.simpleMessage("端口"),
    "applicationManagerRefreshAllTip" : MessageLookupByLibrary.simpleMessage("刷新所有应用"),
    "applicationManagerTitle" : MessageLookupByLibrary.simpleMessage("应用管理器"),
    "autoPageAddCheckpointTip" : MessageLookupByLibrary.simpleMessage("添加检查点"),
    "autoPageAddDelayTip" : MessageLookupByLibrary.simpleMessage("添加延迟 (右键单击可以选择延迟),此延迟将会在回放时生效"),
    "autoPageCheckpointsTip" : MessageLookupByLibrary.simpleMessage("检查点是一些需要匹配的图片（您需要圈出图片上的关键位置）"),
    "autoPageCheckpointsTitle" : MessageLookupByLibrary.simpleMessage("检查点"),
    "autoPageConfigApp" : MessageLookupByLibrary.simpleMessage("配置应用"),
    "autoPageContinueTip" : MessageLookupByLibrary.simpleMessage("继续"),
    "autoPageDelayToastTitle" : m0,
    "autoPageDependenciesHint" : MessageLookupByLibrary.simpleMessage("通过拖放Auto文件来添加依赖"),
    "autoPageDependenciesOrderHint" : MessageLookupByLibrary.simpleMessage("你可以通过拖动来调整依赖的执行顺序"),
    "autoPageDependenciesTip" : MessageLookupByLibrary.simpleMessage("依赖会预先执行 (建议将测试用例拆分为多个跳转依赖和一个包含主要测试逻辑的Auto文件)"),
    "autoPageDependenciesTitle" : MessageLookupByLibrary.simpleMessage("依赖"),
    "autoPageDisableKeyboardTip" : MessageLookupByLibrary.simpleMessage("录制中禁止键盘弹出"),
    "autoPageMatchTestFailed" : MessageLookupByLibrary.simpleMessage("匹配测试失败!"),
    "autoPageMatchTestPassed" : MessageLookupByLibrary.simpleMessage("匹配测试通过!"),
    "autoPageOpenRemoteInput" : MessageLookupByLibrary.simpleMessage("打开远程输入"),
    "autoPagePauseTip" : MessageLookupByLibrary.simpleMessage("暂停"),
    "autoPageRemoteInputHint" : MessageLookupByLibrary.simpleMessage("回车发送"),
    "autoPageReplayTip" : MessageLookupByLibrary.simpleMessage("回放"),
    "autoPageSelectApp" : MessageLookupByLibrary.simpleMessage("选择应用"),
    "autoPageStartTip" : MessageLookupByLibrary.simpleMessage("开始"),
    "autoPageStopSaveTip" : MessageLookupByLibrary.simpleMessage("停止录制并保存"),
    "autoPageStopTip" : MessageLookupByLibrary.simpleMessage("停止录制"),
    "cancel" : MessageLookupByLibrary.simpleMessage("取消"),
    "delete" : MessageLookupByLibrary.simpleMessage("删除"),
    "editorTabClose" : MessageLookupByLibrary.simpleMessage("关闭"),
    "editorTabCloseAll" : MessageLookupByLibrary.simpleMessage("关闭所有"),
    "editorTabCloseLeft" : MessageLookupByLibrary.simpleMessage("关闭左侧"),
    "editorTabCloseOther" : MessageLookupByLibrary.simpleMessage("关闭其他"),
    "editorTabCloseRight" : MessageLookupByLibrary.simpleMessage("关闭右侧"),
    "fileManagerNewAutoFile" : MessageLookupByLibrary.simpleMessage("新建Auto文件"),
    "fileManagerNewAutoFileTip" : MessageLookupByLibrary.simpleMessage("右键文件夹新建Auto文件"),
    "fileManagerNewFormFileName" : MessageLookupByLibrary.simpleMessage("文件名"),
    "height" : MessageLookupByLibrary.simpleMessage("高"),
    "ok" : MessageLookupByLibrary.simpleMessage("确定"),
    "open" : MessageLookupByLibrary.simpleMessage("打开"),
    "redo" : MessageLookupByLibrary.simpleMessage("恢复"),
    "refresh" : MessageLookupByLibrary.simpleMessage("刷新"),
    "reportPageCheckpointTitle" : MessageLookupByLibrary.simpleMessage("检查点"),
    "reportPageErrorReason" : m1,
    "reportPageFailureTitle" : MessageLookupByLibrary.simpleMessage("失败"),
    "reportPageLogTitle" : MessageLookupByLibrary.simpleMessage("日志"),
    "reportPageOriginalAppTitle" : MessageLookupByLibrary.simpleMessage("录制App的信息:"),
    "reportPageSuccessTitle" : MessageLookupByLibrary.simpleMessage("成功"),
    "reportPageTab" : MessageLookupByLibrary.simpleMessage("测试报告"),
    "reportPageTestAppTitle" : MessageLookupByLibrary.simpleMessage("回放App的信息:"),
    "resolution" : MessageLookupByLibrary.simpleMessage("分辨率"),
    "save" : MessageLookupByLibrary.simpleMessage("保存"),
    "select" : MessageLookupByLibrary.simpleMessage("选择"),
    "settingsAutoUtil" : MessageLookupByLibrary.simpleMessage("自定义`auto_util`路径"),
    "settingsLanguage" : MessageLookupByLibrary.simpleMessage("语言"),
    "settingsTab" : MessageLookupByLibrary.simpleMessage("设置"),
    "settingsTitle" : MessageLookupByLibrary.simpleMessage("设置"),
    "systemLogTab" : MessageLookupByLibrary.simpleMessage("系统日志"),
    "toastRequireNonEmpty" : m2,
    "toastRequireNonNull" : m3,
    "toolbarApplicationManagerTip" : MessageLookupByLibrary.simpleMessage("应用管理器"),
    "toolbarFileManagerTip" : MessageLookupByLibrary.simpleMessage("文件管理器"),
    "toolbarSettingsTip" : MessageLookupByLibrary.simpleMessage("设置"),
    "toolbarSystemLogTip" : MessageLookupByLibrary.simpleMessage("系统日志"),
    "undo" : MessageLookupByLibrary.simpleMessage("撤销"),
    "unsupportedPageTitle" : MessageLookupByLibrary.simpleMessage("文件格式不支持"),
    "viewDetails" : MessageLookupByLibrary.simpleMessage("查看详情"),
    "width" : MessageLookupByLibrary.simpleMessage("宽"),
    "zoomIn" : MessageLookupByLibrary.simpleMessage("放大"),
    "zoomOut" : MessageLookupByLibrary.simpleMessage("缩小"),
    "zoomReset" : MessageLookupByLibrary.simpleMessage("重置")
  };
}
