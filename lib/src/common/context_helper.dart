import 'package:auto_ide/generated/l10n.dart';
import 'package:flutter/widgets.dart';

extension SContext on BuildContext {
  S get i18{
    return S.of(this);
  }
}