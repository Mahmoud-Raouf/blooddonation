import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:blooddonation/pages/Dashboard/home.dart';
import 'package:blooddonation/pages/Login/login_page.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // يتم استخدام StreamBuilder للتفاعل مع التغييرات في حالة المصادقة
        body: StreamBuilder<User?>(
      // يتم الاستماع إلى تغييرات حالة المصادقة باستخدام FirebaseAuth
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        // يتم فحص ما إذا كان هناك مستخدم قد قام بتسجيل الدخول
        if (snapshot.hasData) {
          // إذا كان هناك مستخدم قد قام بتسجيل الدخول ، نتنقل إلى الشاشة الرئيسية (Home)
          return const Home();
        } else {
          // إذا لم يكن هناك مستخدم قد قام بتسجيل الدخول ، يتم عرض الشاشة (Login)
          return const Login();
        }
      }),
    ));
  }
}
