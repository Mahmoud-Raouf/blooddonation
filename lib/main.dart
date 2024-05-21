import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as se;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:blooddonation/routes/app_pages.dart';
import 'package:blooddonation/routes/app_routes.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // ضمان تهيئة Flutter bindings قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // تعيين تفضيلات اتجاه الشاشة لتكون بورتريه
  se.SystemChrome.setPreferredOrientations([se.DeviceOrientation.portraitDown, se.DeviceOrientation.portraitUp]);

  // تهيئة GetStorage لتخزين البيانات المحلية
  await GetStorage.init();

  // تهيئة Firebase
  await Firebase.initializeApp();

  // تشغيل التطبيق باستخدام MyApp
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // إنشاء حالة لـ MyApp
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, dtype) {
      // Getx
      return GetMaterialApp(
        textDirection: TextDirection.rtl,
        // تعريف سمة التصميم الرئيسية للتطبيق
        theme: ThemeData(
          primaryColor: AppTheme.primaryColor,
          fontFamily: AppTheme.appFontName,
          textTheme: AppTheme.textTheme,
          appBarTheme: const AppBarTheme(
            // تعريف نمط تراكب النظام لشريط الحالة
            systemOverlayStyle: se.SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            // تحديد ألوان تحديد النص
            cursorColor: AppTheme.colorPrimaryTheme,
            selectionColor: AppTheme.colorPrimaryTheme,
            selectionHandleColor: AppTheme.colorPrimaryTheme,
          ),
        ),
        // تعيين الانتقال الافتراضي بين الشاشات
        defaultTransition: Transition.size,
        // تعيين عنوان التطبيق
        title: Strings.appName,
        // تعيين الطريق الابتدائي للتطبيق
        initialRoute: AppRoute.Auth,
        // تعريف قائمة الصفحات ومساراتها
        getPages: AppPages.list,
        // تعطيل إظهار الشارة التحذيرية في وضع التصحيح
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
