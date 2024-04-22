import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:blooddonation/theme/app_theme.dart';

class GlassmorPhism extends StatelessWidget {
  final double blure;
  final double opacity;
  final Widget child;
  final double radius;

  const GlassmorPhism({Key? key, this.radius = 20, required this.blure, required this.child, required this.opacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // إنشاء عنصر ClipRRect لتقديم زاوية مستديرة للعنصر
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius), // تحديد نصف قطر الزاوية المستديرة
      child: BackdropFilter(
        // إنشاء BackdropFilter لتطبيق تأثير الضباب
        filter: ImageFilter.blur(sigmaX: blure, sigmaY: blure), // تحديد قوة التأثير الضبابي (التمويج)
        child: Container(
          decoration: BoxDecoration(
            // إعدادات التصميم للحاوية
            color: AppTheme.colorWhite.withOpacity(opacity), // لون الخلفية مع درجة شفافية
            borderRadius: BorderRadius.all(Radius.circular(radius)), // زوايا مستديرة للحاوية
            border: Border.all(width: 1.5, color: AppTheme.colorWhite.withOpacity(0.3)), // حدود مع لون وشفافية محددة
          ),
          child: child, // العنصر الفعلي الذي يتم تضمينه داخل الحاوية
        ),
      ),
    );
  }
}
