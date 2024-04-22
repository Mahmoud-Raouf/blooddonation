import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooddonation/routes/app_routes.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/widgets/Custom_Textfield.dart';
import 'package:blooddonation/widgets/Custombutton.dart';
import 'package:blooddonation/widgets/custom_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.forgotPasswordColor, // لون خلفية الشاشة
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: Constant.forgotTopPadding, // تعيين هامش للأعلى
          ),
          child: Column(
            children: [
              CustomText(
                title: Strings.forgotPassword, // عنوان "نسيت كلمة المرور"
                fontfamily: Strings.emptyString, // نوع الخط
                fontSize: Constant.forgotTextSize, // حجم الخط
                fontWight: FontWeight.w500, // وزن الخط
                wordSpacing: Constant.zero, // تباعد الكلمات
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: Constant.forgotSubtitleTopPadding,
                  left: Constant.forgotSubtitleLeftPadding,
                  right: Constant.forgotSubtitleRightPadding,
                  bottom: Constant.forgotSubtitleBottomPadding,
                ),
                child: CustomText(
                  textAlign: TextAlign.center, // محاذاة النص إلى الوسط
                  height: Constant.forgotSubtitleHeight, // ارتفاع النص
                  fontfamily: Strings.emptyString, // نوع الخط
                  fontSize: Constant.forgotSubtitleSize, // حجم الخط
                  color: AppTheme.forgotSubtitleColor, // لون النص
                  title: Strings.enterEmailornumbertoreset, // نص الإرشادات
                ),
              ),
              CustomTextFeild(
                hintText: Strings.enterEmailOrNumber, // نص تلميح الحقل
                prefixIcon: const Icon(
                  Icons.lock_reset_outlined, // أيقونة قفل إعادة التعيين
                  size: Constant.resetIconSize, // حجم الأيقونة
                  color: Colors.black38, // لون الأيقونة
                ),
              ),
              CustomButton(
                topPadding: Constant.sendOtpButtonTopPadding, // تعيين هامش للزر
                backgroundColor: AppTheme.themeColor, // لون خلفية الزر
                borderColor: AppTheme.themeColor, // لون حدود الزر
                textColor: AppTheme.colorWhite, // لون نص الزر
                buttonTitle: Strings.sendOtp, // نص الزر
                onTap: () async {
                  Get.toNamed(AppRoute.SUCCESSFULL, arguments: [
                    Strings.resetEmailsentSuccesfully
                  ]); // نقل المستخدم إلى صفحة نجاح إرسال البريد الإلكتروني لإعادة تعيين كلمة المرور
                },
                height: Constant.customButtonHeight, // ارتفاع الزر
              ),
            ],
          ),
        ),
      ),
    );
  }
}
