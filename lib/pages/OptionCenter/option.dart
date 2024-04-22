import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooddonation/routes/app_routes.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/widgets/Custombutton.dart';
import 'package:blooddonation/widgets/custom_text.dart';
import 'package:blooddonation/widgets/no_appbar.dart';
import '../../widgets/app_logo.dart';

class Option extends StatefulWidget {
  const Option({super.key});

  @override
  State<Option> createState() => _OptionState();
}

// _OptionState هذا هو الفصل الذي يتحكم في واجهة الخيارات.
class _OptionState extends State<Option> {
  double? height;
  double? width;

  @override
  Widget build(BuildContext context) {
    // الحصول على ارتفاع وعرض الشاشة باستخدام MediaQuery
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // بداية بناء واجهة المستخدم
    return Scaffold(
      // NoAppBar(): واجهة لعرض الشاشة بدون AppBar
      appBar: NoAppBar(),
      // Column(): ترتيب العناصر عمودياً
      body: Column(
        children: [
          // AppLogo(): عنصر لعرض الشعار
          AppLogo(),
          Constant.sizedBoxHeight15, // عنصر فارغ لإضافة فاصل بارتفاع 15
          SizedBox(
            // SizedBox(): تستخدم لتحديد العرض والارتفاع المحددين للعنصر داخلها
            width: width! / Constant.signintoAppToenjoyBoxtwidth,
            child: CustomText(
              // CustomText(): عنصر لعرض نص مخصص
              title: Strings.signintoAppToenjoy,
              fontWight: FontWeight.bold,
              fontSize: Constant.signintoAppToenjoyTextSize,
              color: Colors.black45,
              height: Constant.signintoAppToenjoyBoxtheight,
              textAlign: TextAlign.center,
            ),
          ),
          CustomButton(
            // CustomButton(): عنصر زر مخصص
            onTap: () {
              Get.toNamed(AppRoute.LOGIN); // انتقال إلى الشاشة التالية عند النقر على الزر
            },
            backgroundColor: AppTheme.themeColor,
            borderColor: AppTheme.themeColor,
            buttonTitle: Strings.login,
            height: Constant.customButtonHeight,
            textColor: AppTheme.colorWhite,
          ),
          CustomButton(
            // CustomButton(): عنصر زر مخصص
            onTap: () {
              Get.toNamed(AppRoute.SIGNUP); // انتقال إلى الشاشة التالية عند النقر على الزر
            },
            backgroundColor: AppTheme.colorWhite,
            borderColor: AppTheme.themeColor,
            buttonTitle: Strings.signUp,
            height: Constant.customButtonHeight,
            textColor: AppTheme.themeColor,
          )
        ],
      ),
    );
  }
}
