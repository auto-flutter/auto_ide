import 'dart:ui';

import 'package:auto_core/auto_core.dart';

class RatioRectHelper {
  static RatioRect resolve(Rect ref, Rect res) {
    final h = ref.height;
    final w = ref.width;

    double left = (res.left - ref.left) / w;
    double top = (res.top - ref.top) / h;
    double right = (res.right - ref.left) / w;
    double bottom = (res.bottom - ref.top) / h;
    return RatioRect(left, top, right, bottom);
  }

  static Rect transform(Rect ref, RatioRect ratioRect) {
    final h = ref.height;
    final w = ref.width;
    return Rect.fromLTRB(
        ref.left + (ratioRect.leftRatio * w),
        ref.top + (ratioRect.topRatio * h),
        ref.left + (ratioRect.rightRatio * w),
        ref.top + (ratioRect.bottomRatio * h));
  }
}
