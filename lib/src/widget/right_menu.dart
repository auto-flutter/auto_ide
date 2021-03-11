import 'package:auto_ide/src/provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showRightMenu(List<MenuGroup> groupItems,
    {EdgeInsetsGeometry padding, BuildContext targetContext, Offset target}) {
  BotToast.showAttachedWidget(
      preferDirection: PreferDirection.rightTop,
      target: target,
      targetContext: targetContext,
      attachedBuilder: (cancel) => RightMenu(
          groupItems: groupItems, padding: padding, onTapItem: cancel));
}

class MenuGroup {
  final List<MenuItem> items;

  MenuGroup({@required this.items});
}

class MenuItem {
  final String text;
  final VoidCallback onTap;

  MenuItem({
    @required this.text,
    @required this.onTap,
  });
}

class RightMenu extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  final List<MenuGroup> groupItems;

  final VoidCallback onTapItem;

  const RightMenu(
      {Key key,
      @required this.groupItems,
      this.padding = EdgeInsets.zero,
      this.onTapItem})
      : super(key: key);

  List<Widget> _buildChildren(RightMenuStyle style) {
    bool isFirst = true;
    return groupItems.fold(<Widget>[], (List<Widget> previousValue, element) {
      if (!isFirst) {
        previousValue.add(Divider(
          height: 3,
          thickness: 1,
          indent: 8,
          endIndent: 8,

          // color: Colors.black,
        ));
      } else {
        isFirst = false;
      }
      previousValue
          .addAll(element.items.map((e) => _buildItem(e.text, e.onTap, style)));
      return previousValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<RightMenuStyle>();
    return Material(
      elevation: 16,
      borderRadius: BorderRadius.circular(6),
      color: style.color,
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(style),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String text, VoidCallback onTap, RightMenuStyle style) {
    return InkWell(
        onTap: () {
          onTap();
          onTapItem?.call();
        },
        hoverColor: style.hoverColor,
        child: Container(
          alignment: Alignment.topLeft,
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 5) + padding,
          child: Text(
            text,
            style: TextStyle(fontSize: 13),
          ),
        ));
  }
}
