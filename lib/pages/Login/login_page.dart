import 'package:blooddonation/pages/Signup/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooddonation/pages/Dashboard/home.dart';
import 'package:blooddonation/pages/Login/login_controller.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/widgets/Custom_Textfield.dart';
import 'package:blooddonation/widgets/Custombutton.dart';
import 'package:blooddonation/widgets/app_logo.dart';
import 'package:blooddonation/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double? height;
  double? width;
  final loginController = Get.put(LoginController());
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _loginErrorMessage;

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String userId = FirebaseAuth.instance.currentUser!.uid;

      CollectionReference signupNotifications = FirebaseFirestore.instance.collection('notifications');

      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat.yMd().add_jm();
      String currentTimestamp = formatter.format(now);
      signupNotifications.add({
        'userUid': userId,
        'title': "تسجيل دخول",
        'description':
            "مرحبًا بك في تطبيق Blood Donation! لقد تم تسجيل دخولك بنجاح في تمام الساعه ال $currentTimestamp",
        'time': currentTimestamp,
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } catch (error) {
      setState(() {
        _loginErrorMessage = "كلمة المرور أو البريد الإلكتروني غير صحيحة";
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // استخدام GetBuilder لإدارة حالة الواجهة
    return GetBuilder(
        init: loginController,
        builder: (cont) {
          // Scaffold كإطار لتصميم الصفحة
          return Scaffold(
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: AppTheme.themeColor, // يمكنك استبدال "Colors.red" باللون الذي تفضله
                  ))
                : GestureDetector(
                    onTap: () {
                      // إخفاء لوحة المفاتيح عند النقر في أي مكان خارج حقول الإدخال
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      color: AppTheme.loginPageColor,
                      height: height,
                      width: width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // شعار التطبيق
                            AppLogo(),

                            // حقل إدخال للبريد الإلكتروني
                            CustomTextFeild(
                                hintText: Strings.enterUserName,
                                controller: _emailController,
                                prefixIcon: const Icon(
                                  Icons.person_4_outlined,
                                  color: AppTheme.textFieldIconColor,
                                )),

                            // حقل إدخال لكلمة المرور
                            CustomTextFeild(
                                controller: _passwordController,
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: AppTheme.textFieldIconColor,
                                ),
                                hintText: Strings.password,
                                // إظهار أو إخفاء كلمة المرور
                                isObscureText: loginController.isVisible,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    // تحديث حالة الرؤية لكلمة المرور
                                    loginController.isVisible = !loginController.isVisible;
                                    loginController.update();
                                  },
                                  child: Icon(
                                    loginController.isVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.black45,
                                  ),
                                )),

                            // زر تسجيل الدخول
                            CustomButton(
                              backgroundColor: AppTheme.customButtonBgColor,
                              borderColor: AppTheme.customButtonBgColor,
                              buttonTitle: Strings.login,
                              height: Constant.customButtonHeight,
                              onTap: () {
                                setState(() {
                                  isLoading = true; // تغيير حالة التحميل لتظهر علامة التحميل
                                });
                                signIn().then((_) {
                                  setState(() {
                                    isLoading = false; // تغيير حالة التحميل لإخفاء علامة التحميل
                                  });
                                });
                              },
                              textColor: AppTheme.colorWhite,
                            ),

                            // إذا كانت هناك رسالة خطأ، قم بعرضها
                            if (_loginErrorMessage != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  _loginErrorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            // رابط لصفحة التسجيل
                            InkWell(
                              highlightColor: AppTheme.colorTransprant,
                              splashColor: AppTheme.colorTransprant,
                              onTap: () {
                                Get.to(const SignUp());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: Constant.notMamberTopPadding),
                                    child: CustomText(
                                      title: Strings.notAMember,
                                      fontfamily: Strings.emptyString,
                                      fontWight: FontWeight.bold,
                                      color: AppTheme.colorblack38,
                                      fontSize: Constant.notMamberTextSize,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: Constant.notMamberTopPadding),
                                    child: CustomText(
                                      title: Strings.registerNow,
                                      fontfamily: Strings.emptyString,
                                      fontWight: FontWeight.bold,
                                      color: AppTheme.themeColor,
                                      fontSize: Constant.notMamberTextSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }

  // دالة تُنشئ خط فاصل بين العناصر
  Widget devider() {
    return Container(
      height: Constant.dividerSize,
      width: width! / Constant.size5,
      color: AppTheme.colorblack12,
    );
  }
}
