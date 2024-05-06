import 'package:get/get.dart';
import 'package:blooddonation/pages/Dashboard/home.dart';
import 'package:blooddonation/pages/Login/auth.dart';
import 'package:blooddonation/pages/OptionCenter/option.dart';
import 'package:blooddonation/pages/Login/login_page.dart';
import 'package:blooddonation/routes/app_routes.dart';

import '../pages/ForgotPassword/Succesfullsent.dart';
import '../pages/ForgotPassword/forgot_password.dart';

/*
  هذا الكود يقوم بتعريف الصفحات في التطبيق باستخدام مكتبة GetX لإدارة حالة التطبيق.
  يتم تحديد كل صفحة بواسطة GetPage وتحديد اسم الصفحة والعرض المرتبط بها.

  - AppPages: يعتبر هذا الفئة المسؤولة عن تحديد وتكوين جميع الصفحات في التطبيق.
  - GetPage: يستخدم لتعريف صفحة وربطها بالشاشة المقابلة (page) وتحديد اسم الصفحة.
  - name: يحدد اسم الصفحة.
  - page: يحدد الشاشة المقابلة للصفحة.

  يمكنك استخدام هذه القائمة من الصفحات في GetMaterialApp أو GetMaterialApp.builder لتحديد الشاشة الرئيسية للتطبيق.

*/
class AppPages {
  static var list = [
    // GetPage(name: AppRoute.SIGNUP, page: () => const SignUp()),
    GetPage(name: AppRoute.LOGIN, page: () => const Login()),
    GetPage(name: AppRoute.OPTION, page: () => const Option()),
    GetPage(name: AppRoute.FORGOT_PASSWORD, page: () => const ForgotPassword()),
    GetPage(name: AppRoute.SUCCESSFULL, page: () => const SuccessfullSent()),
    GetPage(name: AppRoute.HOME, page: () => const Home()),
    GetPage(name: AppRoute.Auth, page: () => const Auth()),
  ];
}
