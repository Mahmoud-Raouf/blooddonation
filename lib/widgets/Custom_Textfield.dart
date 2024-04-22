import 'package:flutter/material.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:blooddonation/util/constants.dart';

class CustomTextFeild extends StatefulWidget {
  CustomTextFeild(
      {super.key,
      this.hintText = Strings.emptyString,
      this.isObscureText = Constant.isFlase,
      this.leftPadding = 20,
      this.rightPadding = 20,
      this.topPadding = 20,
      this.onChanged,
      this.onTap,
      this.bottomPadding = Constant.zero,
      this.contentLeftPadding = Constant.customfieldContentLeftPadding,
      this.contentRightPadding = Constant.customfieldContentRightPadding,
      this.contentTopPadding = Constant.customfieldContentTopPadding,
      this.contentBottomPadding = Constant.customfieldContentBottomPadding,
      this.hintSize = Constant.customfieldHintSize,
      this.prefixIcon,
      this.controller,
      this.suffixIcon});

  double contentLeftPadding;
  double contentRightPadding;
  double contentTopPadding;
  double contentBottomPadding;
  double bottomPadding;
  String hintText;
  Widget? prefixIcon;
  bool isObscureText;
  Widget? suffixIcon;
  double leftPadding;
  double rightPadding;
  double topPadding;
  double hintSize;
  void Function(String)? onChanged;
  void Function()? onTap;
  TextEditingController? controller;

  @override
  State<CustomTextFeild> createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      // تعيين حواف التبديل (Padding) باستخدام قيم من الـ widget
      padding: EdgeInsets.only(
        bottom: widget.bottomPadding,
        left: widget.leftPadding,
        right: widget.rightPadding,
        top: widget.topPadding,
      ),
      child: Container(
        // إعدادات الحاوية
        padding: EdgeInsets.zero, // إزالة التبديل
        margin: EdgeInsets.zero, // إزالة التبديل
        decoration: BoxDecoration(
            boxShadow: [Constant.boxShadow(color: AppTheme.greyColor)]), // إعداد الظل باستخدام متغير خارجي

        // عنصر الإدخال (TextFormField) لإدخال النص
        child: TextFormField(
          controller: widget.controller, // تحديد وحدة التحكم للحصول على أو تحديث النص المدخل
          onTap: widget.onTap, // دالة التفاعل عند النقر على النص المدخل
          onChanged: widget.onChanged, // دالة التفاعل عندما يتغير النص المدخل
          validator: (value) => value!.isNotEmpty ? null : Strings.invalidInput, // التحقق من صحة الإدخال
          autovalidateMode: AutovalidateMode.onUserInteraction, // تمكين التحقق التلقائي عند تفاعل المستخدم
          obscureText: widget.isObscureText, // إخفاء النص إذا كانت قيمة isObscureText صحيحة

          // تصميم الإدخال (Decoration)
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon, // أيقونة تظهر قبل النص المدخل
            suffixIcon: widget.suffixIcon, // أيقونة تظهر بعد النص المدخل
            hintText: widget.hintText, // نص تلميح الإدخال عند عدم وجود قيمة
            hintStyle: TextStyle(
              fontFamily: Strings.fontfamily,
              fontSize: widget.hintSize,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
            isDense: true,

            fillColor: AppTheme.colorWhite,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.customFocusColor),
              borderRadius: BorderRadius.circular(Constant.customTextfieldCorner),
            ),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constant.customTextfieldCorner),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppTheme.colorTransprant),
              borderRadius: BorderRadius.circular(Constant.customTextfieldCorner),
            ),
          ),
        ),
      ),
    );
  }
}
