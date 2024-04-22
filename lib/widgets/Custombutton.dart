import 'package:flutter/material.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/widgets/custom_text.dart';

class CustomButton extends StatefulWidget {
  double height;
  Color borderColor;
  Color backgroundColor;
  Color textColor;
  String buttonTitle;
  double leftPadding;
  double rightPadding;
  double topPadding;
  double bottomPadding;

  void Function()? onTap;
  CustomButton(
      {super.key,
      required this.backgroundColor,
      required this.borderColor,
      required this.buttonTitle,
      this.height = Constant.customButtonHeight,
      required this.textColor,
      this.leftPadding = 20,
      this.rightPadding = 20,
      this.bottomPadding = 0,
      this.topPadding = 20,
      this.onTap});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double? ht;

  @override
  Widget build(BuildContext context) {
    ht = MediaQuery.of(context).size.height;

    return Padding(
      // تعيين حواف التبديل (Padding) باستخدام قيم من الـ widget
      padding: EdgeInsets.only(
        left: widget.leftPadding,
        right: widget.rightPadding,
        bottom: widget.bottomPadding,
        top: widget.topPadding,
      ),
      child: InkWell(
        // عنصر اللمس (InkWell) لتفعيل النقر
        borderRadius: BorderRadius.circular(15), // إعداد حدود اللمس للتصميم المستدير
        onTap: widget.onTap, // دالة التفاعل عند النقر
        child: Container(
          height: ht! * widget.height, // تحديد ارتفاع الحاوية بناءً على ارتفاع الشاشة والارتفاع المعطى
          decoration: BoxDecoration(
            boxShadow: [Constant.boxShadow(color: widget.backgroundColor)], // إعداد الظل باستخدام متغير خارجي
            color: widget.backgroundColor, // لون الخلفية
            borderRadius: BorderRadius.circular(15), // حدد شكل الحاوية
            border: Border.all(color: widget.borderColor), // حدد لون الحدود
          ),
          child: Center(
            child: CustomText(
              title: widget.buttonTitle, // نص الزر
              color: widget.textColor, // لون النص
              fontWight: FontWeight.bold, // سمك الخط
            ),
          ),
        ),
      ),
    );
  }
}
