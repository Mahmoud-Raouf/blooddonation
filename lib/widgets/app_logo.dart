import 'package:flutter/material.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:blooddonation/util/resources.dart';
import 'package:blooddonation/widgets/custom_text.dart';

// تعريف عنصر شعار التطبيق
class AppLogo extends StatefulWidget {
  double logoHeight; // ارتفاع شعار التطبيق
  double logoWidth; // عرض شعار التطبيق

  AppLogo({super.key, this.logoHeight = 6.5, this.logoWidth = 3});

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
  double? height; // ارتفاع الشاشة
  double? width; // عرض الشاشة

  @override
  Widget build(BuildContext context) {
    // الحصول على ارتفاع وعرض الشاشة
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // بناء عنصر الشعار
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            // إعداد ارتفاع وعرض عنصر الشعار
            height: height! / widget.logoHeight,
            width: width! / widget.logoWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(image: AssetImage(appLogo), fit: BoxFit.cover)),
          ),
        ),
        // إضافة نص تحت الشعار باستخدام CustomText
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            title: Strings.appName,
            height: 1.5,
            fontWight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
