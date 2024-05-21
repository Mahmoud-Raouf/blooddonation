import 'dart:ui';

import 'package:blooddonation/webservices/firebase_data.dart';
import 'package:blooddonation/widgets/_appbar.dart';
import 'package:flutter/material.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/widgets/Custombutton.dart';
import 'package:blooddonation/widgets/custom_text.dart';
import 'package:blooddonation/widgets/no_appbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class allHospitalDonationRequests extends StatefulWidget {
  const allHospitalDonationRequests({super.key});

  @override
  State<allHospitalDonationRequests> createState() => _allHospitalDonationRequestsState();
}

class _allHospitalDonationRequestsState extends State<allHospitalDonationRequests> {
  double height = Constant.zero;
  double width = Constant.zero;
  static String? hospitalsId;
  String userId = "";
  static String? userRole;

  static Future<void> initialize() async {
    getclinicAppointmentsDocument();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserRole().then((role) {
      setState(() {
        userRole = role;
      });
    });
    getCurrentUserUid().then((uid) {
      setState(() {
        userId = uid;
        print("userId :::::::::::: $userId");
      });
    });
    getclinicAppointmentsDocument().then(
      (documentId) {
        setState(() {
          hospitalsId = documentId;
          print("userId :::::::::::: $userId");
        });
      },
    );
  }

  Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance.collection('hospitals').doc(hospitalsId).collection('donationRequest').snapshots();
  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery للحصول على أبعاد الشاشة
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // Scaffold: الهيكل الرئيسي للصفحة
    return Scaffold(
        appBar: NoAppBar(
          colors: AppTheme.colorblack,
        ),
        body: Scaffold(
          backgroundColor: AppTheme.colorTransprant,
          appBar: NoAppBar(),
          body: Padding(
            padding: const EdgeInsets.only(
              left: Constant.bookingTileLeftPadding,
              right: Constant.bookingTileRightPadding,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: Constant.constantPadding(Constant.SIZE100 / 2),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 300),
                  child: Column(
                    children: [
                      // شريط العنوان الخاص بالتطبيق
                      CustomAppBar(
                        title: "طلبات التبرع الخاصة بك",
                        space: Constant.SIZE15,
                        leftPadding: 15,
                        bottomPadding: 10,
                        onTap: () {},
                      ),
                      SizedBox(
                        height: height * Constant.searchBodyHeight,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('hospitals')
                              .doc(hospitalsId)
                              .collection('donationRequest')
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                              return ListView.builder(
                                padding: EdgeInsets.only(
                                  left: Constant.searchTileListLeftPadding,
                                  bottom: height * Constant.searchTileListBottomPadding,
                                  right: Constant.searchTileListRightPadding,
                                  top: Constant.searchTileListTopPadding,
                                ),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot document = snapshot.data!.docs[index];
                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                  String title = data['title'];
                                  String bloodGroups = data['bloodGroups'];
                                  String description = data['description'];
                                  int numberDonorsRequired = data['numberDonorsRequired'];
                                  String documentDetailuid = document.id;

                                  DateTime now2 = data['date']?.toDate() ?? DateTime.now();
                                  DateFormat formatter2 = DateFormat.yMd().add_jm();
                                  String date = formatter2.format(now2);

                                  return Stack(
                                    children: [
                                      // تأثير زجاجي خلفي للعنصر
                                      BackdropFilter(
                                        filter:
                                            ImageFilter.blur(sigmaX: Constant.blurSigmaX, sigmaY: Constant.blurSigmaY),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // إخفاء لوحة المفاتيح عند النقر على العنصر
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(Constant.searchTileMargin),
                                          padding:
                                              const EdgeInsets.only(bottom: Constant.searchTileContentBottomPadding),
                                          decoration: Constant.boxDecoration,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),

                                                    CustomText(
                                                      title: title,
                                                      fontSize: Constant.searchTileTitleSize,
                                                      color: AppTheme.colorblack,
                                                      fontWight: FontWeight.w900,
                                                    ),
                                                    // عنوان التفاصيل والموقع
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                      child: SizedBox(
                                                        width: width * 0.7,
                                                        child: CustomText(
                                                          title: "وصف الطلب : $description",
                                                          fontSize: width * 0.04,
                                                          color: AppTheme.tripCardLocationColor,
                                                          fontWight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: width * 0.75,
                                                      child: Text(
                                                        "نوع الفصيلةالمطلوبة : $bloodGroups",
                                                        style: TextStyle(
                                                          fontSize: width * 0.04,
                                                          color: AppTheme.tripCardLocationColor,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.75,
                                                      child: Text(
                                                        "ميعاد التبرع : $date",
                                                        style: TextStyle(
                                                          fontSize: width * 0.04,
                                                          color: AppTheme.tripCardLocationColor,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.75,
                                                      child: Text(
                                                        "عدد المطلوبين للتبرع : $numberDonorsRequired",
                                                        style: TextStyle(
                                                          fontSize: width * 0.04,
                                                          color: AppTheme.tripCardLocationColor,
                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 30,
                                                      ),
                                                      child: SizedBox(
                                                        width: width * 0.7,
                                                        child: CustomButton(
                                                          backgroundColor: AppTheme.themeColor,
                                                          borderColor: AppTheme.themeColor,
                                                          // width: 50,
                                                          buttonTitle: "حذف الطلب",
                                                          height: Constant.customButtonHeight / 1.5,
                                                          textColor: AppTheme.colorWhite,
                                                          onTap: () async {
                                                            Future deleteDonation() async {
                                                              try {
                                                                await FirebaseFirestore.instance
                                                                    .collection('hospitals')
                                                                    .doc(hospitalsId)
                                                                    .collection('donationRequest')
                                                                    .doc(documentDetailuid)
                                                                    .delete();

                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  const SnackBar(
                                                                    duration: Duration(seconds: 3),
                                                                    showCloseIcon: true,
                                                                    content: Text("تم حذف طلب التبرع بنجاح "),
                                                                  ),
                                                                );
                                                              } catch (e) {
                                                                print('Error deleting donation request: $e');
                                                                // Handle the error accordingly
                                                              }
                                                            }

                                                            deleteDonation();
                                                          },
                                                        ),
                                                      ),
                                                    )

                                                    // Padding(
                                                    //   padding: EdgeInsets.only(
                                                    //     right: width * 0.35,
                                                    //   ),
                                                    //   child: InkWell(
                                                    //     onTap: () async {
                                                    //       // عرض تفاصيل المزيد
                                                    //       homeController.index = Constant.INT_SIX;
                                                    //       homeController.update();
                                                    //       setState(() {
                                                    //         documentDetailId = documentDetailuid;
                                                    //       });
                                                    //     },
                                                    //     child: CustomText(
                                                    //       topPadding: Constant.moreTextTopPadding,
                                                    //       title: Strings.more,
                                                    //       fontSize: Constant.moreTextSize,
                                                    //       fontfamily: Strings.emptyString,
                                                    //       color: AppTheme.themeColor,
                                                    //       fontWight: FontWeight.w400,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              // زر "المزيد"
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return const SizedBox(); // التعامل مع حالة عدم وجود بيانات
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
