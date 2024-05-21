import 'package:flutter/material.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/constants.dart';

class CustomText extends StatefulWidget {
  String title;
  String fontfamily;
  double fontSize;
  Color color;
  FontWeight fontWight;
  double height;
  TextAlign textAlign;
  double wordSpacing;
  double topPadding;
  double bottomPadding;
  double leftPadding;
  double rightPadding;

  CustomText(
      {super.key,
      this.color = Colors.black,
      this.fontSize = Constant.midiumn,
      this.fontWight = AppTheme.fontWeight,
      this.fontfamily = AppTheme.appFontName,
      required this.title,
      this.height = 1.0,
      this.wordSpacing = 0,
      this.bottomPadding = Constant.zero,
      this.topPadding = Constant.zero,
      this.leftPadding = Constant.zero,
      this.rightPadding = Constant.zero,
      this.textAlign = TextAlign.justify});

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      // تعيين حواف التبديل (Padding) باستخدام قيم من الـ widget
      padding: EdgeInsets.only(
        left: widget.leftPadding,
        right: widget.rightPadding,
        top: widget.topPadding,
        bottom: widget.bottomPadding,
      ),
      child: Text(
        widget.title, // نص العنصر الذي سيتم عرضه
        textAlign: TextAlign.right, // توجيه النص (اليمين، الوسط، اليسار)
        style: TextStyle(
          color: widget.color, // لون النص
          fontFamily: widget.fontfamily, // نوع الخط
          fontWeight: widget.fontWight, // سمك الخط
          fontSize: widget.fontSize, // حجم الخط
          wordSpacing: 0.5, // تباعد الكلمات
          height: widget.height, // ارتفاع السطر
        ),
      ),
    );
  }
}
