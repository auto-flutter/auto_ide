import 'package:auto_ide/generated/l10n.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastSafeArea extends StatelessWidget {
  final Widget child;

  const ToastSafeArea({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
            builder: (_) => Material(
                  type: MaterialType.transparency,
                  child: child,
                ))
      ],
    );
  }
}

class ToastUtil {
  static void nullError(String arg) {
    error(S.current.toastRequireNonNull(arg));
  }

  static void emptyError(String arg) {
    error(S.current.toastRequireNonEmpty(arg));
  }

  static void error(Object text) {
    BotToast.showText(
        text: text.toString().trim(),
        duration: Duration(seconds: 10),
        textStyle: TextStyle(color: Colors.redAccent),
        align: const Alignment(0, 0.6),
        contentColor: const Color(0xff3b2f2f),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        borderRadius: BorderRadius.circular(8));
  }

  static void dialog(
      {@required String leftText,
      @required String rightText,
      @required String content,
      VoidCallback onTapLeft,
      VoidCallback onTapRight}) {
    BotToast.showAnimationWidget(
        wrapAnimation: (controller, __, child) {
          return FadeTransition(
              opacity: controller, child: ToastSafeArea(child: child));
        },
        animationDuration: Duration(milliseconds: 300),
        clickClose: true,
        backgroundColor: Colors.black26,
        toastBuilder: (cancel) => Builder(
              builder: (context) => Center(
                child: Material(
                  color: const Color(0xff363333),
                  borderRadius: BorderRadius.circular(8),
                  elevation: 8,
                  child: Container(
                    padding: const EdgeInsets.only(top: 4),
                    constraints: BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            content,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFF1565C0)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                    ))),
                                  ),
                                  onPressed: () {
                                    onTapLeft?.call();
                                    cancel();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      leftText,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ),
                            Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    onTapRight?.call();
                                    cancel();
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8),
                                    ))),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(rightText),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
