import 'package:auto_core/protos/app_info.pbserver.dart';
import 'package:auto_ide/src/common/common.dart';
import 'package:auto_ide/src/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppInfoPanel extends StatelessWidget {
  final AppInfo appInfo;

  AppInfoPanel(this.appInfo);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    children
        .add(_buildInfoItem(context, context.i18.appInfoPanelPlatform, appInfo.platform.toString()));
    children.add(Divider(height: 1, thickness: 1));
    children.add(_buildInfoItem(context, context.i18.appInfoPanelMode, appInfo.mode.toString()));
    if (appInfo.hasDeviceName()) {
      children.add(Divider(height: 1, thickness: 1));
      children.add(_buildInfoItem(
          context, context.i18.appInfoPanelDeviceName, appInfo.deviceName.toString()));
    }
    if (appInfo.hasAutoApiVersion()) {
      children.add(Divider(height: 1, thickness: 1));
      children.add(_buildInfoItem(
          context, context.i18.appInfoPanelApiVersion, appInfo.autoApiVersion.toString()));
    }
    if (appInfo.hasPhysicalWidth()&&appInfo.hasPhysicalHeight()) {
      children.add(Divider(height: 1, thickness: 1));
      children.add(_buildInfoItem(
          context, context.i18.resolution, '${appInfo.physicalWidth.toInt()}*${appInfo.physicalHeight.toInt()}'));
    }
    return Consumer<ApplicationInfoPanelStyle>(
      builder: (_,style,__)=>Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: style.panelColor,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(minWidth: 250),
          padding: const EdgeInsets.all(8.0).copyWith(right: 64, left: 20),
          child: SelectableText(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: SelectableText(
            value,
          ),
        ),
      ],
    );
  }
}
