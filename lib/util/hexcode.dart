import 'package:flutter/material.dart';

/*
  هذا الكود يعرف فئة HexColor التي تستخدم لتحويل لون من تمثيل Hex إلى تمثيل Color في Flutter.

  - HexColor: هي توسيع لفئة Color وتأخذ سلسلة Hex كمدخل لإنشاء كائن من اللون.
  - يتم استخدام _getColorFromHex() لتحويل سلسلة Hex إلى قيمة عددية (int) تمثل اللون.

  مثال على استخدام HexColor:
  HexColor('#FF0000') لتمثيل اللون الأحمر.

  يمكنك استخدام هذه الفئة لتحديد الألوان بسهولة باستخدام الأكواد اللونية Hex في تطبيقك.

*/
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
