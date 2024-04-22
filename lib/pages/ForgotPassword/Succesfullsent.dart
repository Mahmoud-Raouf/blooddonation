import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/util/resources.dart';
import 'package:blooddonation/widgets/Custombutton.dart';
import 'package:blooddonation/widgets/custom_text.dart';

class SuccessfullSent extends StatefulWidget {
  const SuccessfullSent({super.key});

  @override
  State<SuccessfullSent> createState() => _SuccessfullSentState();
}

class _SuccessfullSentState extends State<SuccessfullSent> {
  final String data = Get.arguments[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.successFullySentColor, // لون خلفية الشاشة
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: Constant.successfullTopPadding, // تعيين هامش للأعلى
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: Constant.successfullTopPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      title: Strings.successFull, // نص "نجاح"
                      fontfamily: Strings.emptyString, // نوع الخط
                      fontSize: Constant.forgotTextSize, // حجم الخط
                      fontWight: FontWeight.w500, // وزن الخط
                      wordSpacing: Constant.zero, // تباعد الكلمات
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: Constant.successfullCircleTopPadding),
                      child: Container(
                        height: Constant.successfullCircleHeight, // ارتفاع الدائرة
                        width: Constant.successfullCircleWidth, // عرض الدائرة
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Constant.successfullCircleRadius), // نصف قطر الدائرة
                          gradient: LinearGradient(colors: AppTheme.circleBgColor), // التدرج اللوني لخلفية الدائرة
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            right, // أيقونة علامة الصح
                            height: Constant.rightIconHeight, // ارتفاع الأيقونة
                            width: Constant.rightIconWidth, // عرض الأيقونة
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: Constant.successfullSubTitleTopPadding,
                        left: Constant.successfullSubTitleLeftPadding,
                        right: Constant.successfullSubTitleRightPadding,
                        bottom: Constant.successfullSubTitleBottomPadding,
                      ),
                      child: CustomText(
                        textAlign: TextAlign.center, // محاذاة النص إلى الوسط
                        height: Constant.successfullSubTitleHeight, // ارتفاع النص
                        fontfamily: Strings.emptyString, // نوع الخط
                        fontWight: FontWeight.w300, // وزن الخط
                        fontSize: Constant.successfullSubTitleSize, // حجم الخط
                        color: AppTheme.successfullSubTitleColor, // لون النص
                        title: data.toString(), // البيانات المرسلة كنص
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                bottomPadding: Constant.okayButtonBottomPadding, // تعيين هامش للزر
                backgroundColor: AppTheme.themeColor, // لون خلفية الزر
                borderColor: AppTheme.themeColor, // لون حدود الزر
                textColor: AppTheme.colorWhite, // لون نص الزر
                buttonTitle: Strings.okay, // نص الزر
                onTap: () async {
                  Get.back(); // إغلاق الصفحة بعد النقر على الزر
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
