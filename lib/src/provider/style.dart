import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Color _activeColor = const Color(0xFF1565C0);

@immutable
class IdeStyle {
  final ToolBarStyle toolBarStyle;
  final ToolViewStyle toolWindowStyle;
  final FileManagerStyle fileManagerStyle;
  final ApplicationManagerStyle applicationManagerStyle;
  final RightMenuStyle rightMenuStyle;
  final EditorStyle editorStyle;
  final ApplicationInfoPanelStyle applicationInfoPanelStyle;
  final WelcomeStyle welcomeStyle;

  IdeStyle({
    this.toolBarStyle = const ToolBarStyle(),
    this.fileManagerStyle = const FileManagerStyle(),
    this.applicationManagerStyle = const ApplicationManagerStyle(),
    this.toolWindowStyle = const ToolViewStyle(),
    this.rightMenuStyle = const RightMenuStyle(),
    this.editorStyle = const EditorStyle(),
    this.applicationInfoPanelStyle = const ApplicationInfoPanelStyle(),
    this.welcomeStyle = const WelcomeStyle(),
  });
}

class WelcomeStyle {
  final Color color;
  final Color buttonColor;

  const WelcomeStyle({this.color=const Color(0xff1E1E1E), this.buttonColor=_activeColor});

}

@immutable
class ToolBarStyle {
  final double width;
  final Color color;

  const ToolBarStyle({this.width = 50, this.color = const Color(0xff333333)});
}

@immutable
class ToolViewStyle {
  final double mixWidth;
  final double width;
  final double maxWidth;
  final Color color;

  const ToolViewStyle(
      {this.color = const Color(0xff262525),
      this.mixWidth = 200,
      this.width = 300,
      this.maxWidth = 800});
}

@immutable
class FileManagerStyle {
  final double iconSize;
  final Color autoFileColor;
  final Color autorFileColor;
  final Color newAutoFileTipColor;
  final Color dragColor;

  const FileManagerStyle({
    this.iconSize = 16,
    this.autoFileColor = const Color(0xff2196f3),
    this.autorFileColor = const Color(0xffa3a378),
    this.newAutoFileTipColor = const Color(0xff333333),
    this.dragColor = _activeColor,
  });
}

@immutable
class ApplicationManagerStyle {
  final double iconSize;
  final double splashRadius;
  final Color headColor;
  final double titleFontSize;

  const ApplicationManagerStyle({
    this.iconSize = 16,
    this.splashRadius = 24,
    this.titleFontSize = 12,
    this.headColor = const Color(0xff333333),
  });
}

@immutable
class RightMenuStyle {
  final Color color;
  final Color hoverColor;

  const RightMenuStyle(
      {this.color = const Color(0xff333333), this.hoverColor = _activeColor});
}

@immutable
class EditorStyle {
  final Color color;
  final Color dividerColor;
  final Color tabColor;
  final Color tabActiveColor;
  final double tabCloseIconSize;

  final Color primaryButtonColor;
  final Color secondaryButtonColor;
  final Color formColor;
  final Color formSecondaryColor;
  final Color indicatorColor;
  final Color hintColor;
  final Color dependencyButtonColor;
  final Color activeBorderColor;

  const EditorStyle({
    this.color = const Color(0xff1E1E1E),
    this.tabColor = const Color(0xff2D2D2D),
    this.dividerColor = const Color(0xff262525),
    this.tabActiveColor = _activeColor,
    this.tabCloseIconSize = 14,
    this.indicatorColor = _activeColor,
    this.primaryButtonColor = _activeColor,
    this.secondaryButtonColor = const Color(0xff333333),
    this.formColor = const Color(0xff333333),
    this.formSecondaryColor = const Color(0xff262525),
    this.hintColor = const Color(0xff989898),
    this.dependencyButtonColor = const Color(0xff5a5a5a),
    this.activeBorderColor = const Color(0xFF1565C0),
  });
}


class ApplicationInfoPanelStyle {
  final Color panelColor;

  const ApplicationInfoPanelStyle({this.panelColor = const Color(0xff333333)});

  ApplicationInfoPanelStyle copyWith({
    final Color panelColor,
  }) {
    return ApplicationInfoPanelStyle(
      panelColor: panelColor ?? this.panelColor,
    );
  }
}

class StyleProvider extends StatefulWidget {
  final Widget child;

  const StyleProvider({Key key, this.child}) : super(key: key);

  @override
  _StyleProviderState createState() => _StyleProviderState();
}

class _StyleProviderState extends State<StyleProvider> {
  final IdeStyle style = IdeStyle();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: style),
        ProxyProvider<IdeStyle, ToolBarStyle>(
            update: (_, v, __) => v.toolBarStyle),
        ProxyProvider<IdeStyle, ToolViewStyle>(
            update: (_, v, __) => v.toolWindowStyle),
        ProxyProvider<IdeStyle, FileManagerStyle>(
            update: (_, v, __) => v.fileManagerStyle),
        ProxyProvider<IdeStyle, ApplicationManagerStyle>(
            update: (_, v, __) => v.applicationManagerStyle),
        ProxyProvider<IdeStyle, RightMenuStyle>(
            update: (_, v, __) => v.rightMenuStyle),
        ProxyProvider<IdeStyle, EditorStyle>(
            update: (_, v, __) => v.editorStyle),
        ProxyProvider<IdeStyle, ApplicationInfoPanelStyle>(
            update: (_, v, __) => v.applicationInfoPanelStyle),
        ProxyProvider<IdeStyle, WelcomeStyle>(
            update: (_, v, __) => v.welcomeStyle),
      ],
      child: widget.child,
    );
  }
}

