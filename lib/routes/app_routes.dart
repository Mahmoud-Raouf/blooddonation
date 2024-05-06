/*
  هذا الكود يقوم بتعريف جميع الطرق الممكنة في التنقل بين الشاشات في التطبيق.
  يتم تحديد كل طريق بواسطة AppRoute واستخدام ذلك في Get.toNamed() لفتح شاشة معينة.

  - AppRoute: يعتبر هذا الفئة المسؤولة عن تحديد اسماء الطرق في التطبيق.
  - اسماء الطرق معرفة كثوابت (const) ويمكن الوصول إليها من أي مكان في التطبيق.

  يمكنك استخدام هذه الطرق لفتح الشاشات أو تحديد الشاشة الرئيسية في GetMaterialApp.

*/
class AppRoute {
  static const String LOGIN = '/login';
  static const String SPLASH = '/splash';
  // static const String SIGNUP = '/signup';
  static const String TUTORIAL = '/tutorial';
  static const String FORGOT_PASSWORD = '/forgotpassword';
  static const String SUCCESSFULL = '/successfull';
  static const String HOME = '/home';
  static const String OPTION = '/option';
  static const String DETAIL_SCREEN = '/detail';
  static const String PAYMENT = '/payment';
  static const String PAYMENT2 = '/payment2';
  static const String Auth = '/auth';
}
