import 'package:blooddonation/pages/Login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooddonation/pages/Dashboard/home_controller.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/webservices/firebase_data.dart';
import '../../util/hexcode.dart';
import 'profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  HomeController homeController;
  Profile({super.key, required this.homeController});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static String? useruid;

  double? height;
  double? width;
  String _name = "";
  String _age = "";
  String _chronicDiseases = "";
  String _weight = "";

  String _location = "";
  String _numberContent = "";
  String _emailContent = "";
  String _bloodType = "";

  static Future<void> initialize() async {
    getCurrentUseData();
    getCurrentUserNumberPhone();
    getCurrentEmail();
    getCurrentUserLocation();
    getCurrentUserbloodType();
    getCurrentUserAge();
    getCurrentUserWeight();
    getCurrentUserChronicDiseases();
  }

  @override
  void initState() {
    super.initState();
    homeController = widget.homeController;

    // استدعاء دوال الحصول على البيانات عند بداية تحميل الصفحة
    getCurrentUseData().then(
      (name) {
        setState(() {
          _name = name;
        });
      },
    );
    // استخدام Future للحصول على رقم الهاتف للمستخدم الحالي

    getCurrentUserNumberPhone().then((number) {
      setState(() {
        // قم بإرجاع الرقم

        _numberContent = number;
      });
    });
    getCurrentEmail().then((uemail) {
      setState(() {
        _emailContent = uemail;
      });
    });
    getCurrentUserAge().then((age) {
      setState(() {
        _age = age;
      });
    });
    getCurrentUserChronicDiseases().then((chronicDiseases) {
      setState(() {
        _chronicDiseases = chronicDiseases;
      });
    });
    getCurrentUserWeight().then((weight) {
      setState(() {
        _weight = weight;
      });
    });
    getCurrentUserLocation().then((location) {
      setState(() {
        _location = location;
      });
    });
    getCurrentUserbloodType().then((bloodType) {
      setState(() {
        _bloodType = bloodType;
      });
    });

    // تحديث الـ state بمعلومات المستخدم
    setState(() {
      useruid = currentUser.uid;
    });
  }

  HomeController homeController = HomeController();

  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GetBuilder(
      init: profileController,
      builder: (_) {
        return Scaffold(
          backgroundColor:
              profileController.index_ == Constant.INT_THREE ? AppTheme.editProfileBodyColor : AppTheme.colorWhite,
          body: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [HexColor('#D60033'), HexColor('#ca3568').withOpacity(0.6)],
                          begin: Alignment.topCenter,
                          end: Alignment.center)),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: height / 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: height / 30,
                                ),
                                const Text(
                                  'مرحباً بك ',
                                  style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  ' $_name',
                                  style:
                                      const TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height / 2.2),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height / 2.6, left: width / 20, right: width / 20),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                                  BoxShadow(color: Colors.black45, blurRadius: 2.0, offset: Offset(0.0, 2.0))
                                ]),
                                child: Padding(
                                  padding: EdgeInsets.all(width / 20),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                    headerChild('الامراض', _chronicDiseases),
                                    headerChild('فصيلة الدم', _bloodType),
                                    headerChild('العمر', _age),
                                    headerChild('الوزن', _weight),
                                  ]),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: height / 20),
                                child: Column(
                                  children: <Widget>[
                                    infoChild(width, Icons.email, _emailContent),
                                    infoChild(width, Icons.call, _numberContent),
                                    infoChild(width, Icons.location_city, _location),
                                    Padding(
                                      padding: EdgeInsets.only(top: height / 30),
                                      child: Container(
                                        width: width / 3,
                                        height: height / 20,
                                        decoration: BoxDecoration(
                                            color: HexColor('#ca3568'),
                                            borderRadius: BorderRadius.all(Radius.circular(height / 40)),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black87, blurRadius: 2.0, offset: Offset(0.0, 1.0))
                                            ]),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () async {
                                              await FirebaseAuth.instance.signOut();
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder: (context) => const Login()),
                                              );
                                            },
                                            child: const Text('تسجيل الخروج',
                                                style: TextStyle(
                                                    fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget headerChild(String header, String value) => Expanded(
          child: Column(
        children: <Widget>[
          Text(header),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.0, color: HexColor('#ca3568'), fontWeight: FontWeight.bold),
          )
        ],
      ));

  Widget infoChild(double width, IconData icon, data) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: width / 20,
              ),
              Icon(
                icon,
                color: HexColor('#ca3568'),
                size: 36.0,
              ),
              SizedBox(
                width: width / 10,
              ),
              Text(data),
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}
