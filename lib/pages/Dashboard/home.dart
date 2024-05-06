import 'dart:math';

import 'package:blooddonation/pages/Dashboard/allDonationRequests.dart';
import 'package:blooddonation/webservices/firebase_data.dart';
import 'package:blooddonation/widgets/Custombutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:blooddonation/pages/Connects/connects.dart';
import 'package:blooddonation/pages/Dashboard/home_controller.dart';
import 'package:blooddonation/pages/Profile/profile.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/util/places.dart';
import 'package:blooddonation/util/resources.dart';
import 'package:blooddonation/widgets/_appbar.dart';
import 'package:blooddonation/widgets/custom_text.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:blooddonation/widgets/glashMorphisam.dart';
import 'package:blooddonation/widgets/no_appbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double height = Constant.zero;
  double width = Constant.zero;
  Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('hospitals').snapshots();

  final homeController = Get.put(HomeController());
  String documentId = "";
  String documentDetailId = "";
  final String _title = "";
  final String _description1 = "";
  final String _description2 = "";
  final String _subImage1 = "";
  final String _subImage2 = "";
  final String _subImage3 = "";
  final String _subImage4 = "";
  String userId = "";
  String userName = "";
  String userRole = "user";
  String userEmail = "";
  String userBloodType = "";
  String userChronicDiseases = "";
  String userWeight = "";
  String userHeight = "";
  String userAge = "";
  String hospitalSelectedUid = "";

  String generateRandomNumber() {
    Random random = Random(); // إنشاء كائن لتوليد أرقام عشوائية
    String randomNumber = ''; // تهيئة سلسلة فارغة لتخزين الرقم العشوائي

    for (int i = 0; i < 10; i++) {
      // حلقة تكرار لإنشاء رقم عشوائي من 10 خانات
      randomNumber += random.nextInt(10).toString(); // إضافة رقم عشوائي جديد إلى السلسلة
    }
    setState(() {
      randomNumber; // تحديث قيمة الرقم العشوائي في واجهة المستخدم
    });
    return randomNumber; // إرجاع الرقم العشوائي المولّد
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserUid().then((uid) {
      setState(() {
        userId = uid;
      });
    });
    getCurrentUserbloodType().then((bloodType) {
      setState(() {
        userBloodType = bloodType;
      });
    });
    getCurrentUseData().then((name) {
      setState(() {
        userName = name;
      });
    });
    getCurrentEmail().then((uemail) {
      setState(() {
        userEmail = uemail;
      });
    });

    getCurrentUserRole().then((role) {
      setState(() {
        userRole = role;
      });
    });
    getCurrentUserAge().then((age) {
      setState(() {
        userAge = age;
      });
    });
    getCurrentUserWeight().then((weight) {
      setState(() {
        userWeight = weight;
      });
    });
    getCurrentUserChronicDiseases().then((chronicDiseases) {
      setState(() {
        userChronicDiseases = chronicDiseases;
      });
    });
    getCurrentUserHeight().then((height) {
      setState(() {
        userHeight = height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GetBuilder(
        init: homeController,
        builder: (_) {
          return Scaffold(body: _body());
        });
  }

  _body() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // إغلاق لوحة المفاتيح عند النقر على أي مكان في الشاشة
      },
      child: Stack(
        children: [
          Builder(builder: (context) {
            switch (homeController.index) {
              case Constant.INT_ONE:
                return _home(); // عرض واجهة الصفحة الرئيسية
              case Constant.INT_TWO:
                return userRole == 'user'
                    ? Profile(
                        homeController: homeController,
                      )
                    : const allHospitalDonationRequests(); // عرض واجهة الصفحة الشخصية
              case Constant.INT_THREE:
                return const DonationRequest(); // عرض واجهة الصفحة "Connect"
              case Constant.INT_FOUR:
                return allDonationRequests(); // عرض واجهة قائمة الحجوزات

              default:
                return _home();
            }
          }),
          bottomNavBar() // عرض شريط التنقل السفلي
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  List<String> images = [image1, image2, image3, image4, image5, image6];

  mainTitle({
    double topPadding = Constant.categoriesPadding,
    double leftPadding = 0,
    double rightPadding = 0,
    required String title,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: leftPadding, right: rightPadding),
      child: CustomText(
        title: title,
        fontWight: FontWeight.w900,
      ),
    );
  }

  _home() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: homeController.isSearchOpened ? AppTheme.homeBgColor2 : AppTheme.homeBgColor)),
      child: Padding(
        padding: Constant.constantPadding(Constant.SIZE100),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: Constant.homeFirstHeadingPadding,
                    right: Constant.homeFirstHeadingPadding), // هامش للعنصر الرئيسي
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // تنظيم العناصر بشكل أفقي بين الحواف
                  children: [
                    CircleAvatar(
                      radius: Constant.circleImageRadius, // نصف قطر الصورة الدائرية
                      child: IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: AppTheme.colorRed,
                        ), // أيقونة خروج
                        onPressed: () {
                          _signOut(context); // استدعاء دالة الخروج عند النقر
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start, // محاذاة العناصر إلى الأعلى
                      crossAxisAlignment: CrossAxisAlignment.start, // محاذاة العناصر إلى اليسار
                      children: [
                        CustomText(
                          title: Strings.whereDo, // نص العنصر الأول
                          fontfamily: Strings.emptyString, // نوع الخط
                          fontSize: Constant.homeFirstHeadingSize, // حجم الخط
                          fontWight: FontWeight.w400, // وزن الخط
                        ),
                        CustomText(
                          fontSize: Constant.homeFirstHeadingSize, // حجم الخط
                          height: Constant.homeFirstHeadingHeight, // ارتفاع العنصر
                          fontWight: FontWeight.w600, // وزن الخط
                          title: homeController.isSearchOpened
                              ? Strings.youWantToSee
                              : Strings.youWantToGo, // نص العنصر الثاني يعتمد على حالة البحث
                          fontfamily: Strings.emptyString, // نوع الخط
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              planedTile(),
            ],
          ),
        ),
      ),
    );
  }

  planedTile() {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.4,
            width: width,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String name = data['name'];
                String picture = data['picture'];
                String location = data['location'];
                String hospitalSelectedUid = data['uid'];

                String documentuid = document.id;
                return InkWell(
                  onTap: () {
                    homeController.index = Constant.INT_FOUR;
                    homeController.update();
                    setState(() {
                      documentId = documentuid;
                      this.hospitalSelectedUid = hospitalSelectedUid; // حفظ القيمة هنا
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: Constant.planImageTopBoxHeight * 5.5,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Constant.planImageRadius),
                        image: DecorationImage(
                          image: NetworkImage(picture),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Constant.planImageTopBoxPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                GlassmorPhism(
                                  blure: Constant.planImageTopBoxBlurness,
                                  opacity: Constant.planImageTopBoxOpacity,
                                  radius: Constant.planImageTopBoxRadius,
                                  child: SizedBox(
                                    height: Constant.planImageTopBoxHeight * 1.2,
                                    width: Constant.planImageTopBoxWidth * 1.4,
                                    child: Center(
                                      child: CustomText(
                                        title: name,
                                        color: AppTheme.colorblack,
                                        fontfamily: Strings.emptyString,
                                        fontWight: FontWeight.w400,
                                        fontSize: name.length > 6 ? 12 : 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GlassmorPhism(
                                  blure: Constant.planImageTopBoxBlurness,
                                  opacity: Constant.planImageTopBoxOpacity,
                                  radius: Constant.planImageTopBoxRadius,
                                  child: SizedBox(
                                    height: Constant.planImageTopBoxHeight * 1.2,
                                    width: Constant.planImageTopBoxWidth * 1.4,
                                    child: Center(
                                      child: CustomText(
                                        title: location,
                                        color: AppTheme.colorblack,
                                        fontfamily: Strings.emptyString,
                                        fontWight: FontWeight.w400,
                                        fontSize: name.length > 6 ? 12 : 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  allDonationRequests() {
    return Scaffold(
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
                    title: "طلبات التبرع",
                    space: Constant.SIZE15,
                    leftPadding: 15,
                    bottomPadding: 10,
                    onTap: () {
                      // تحديث حالة التطبيق عند النقر على شريط العنوان
                      homeController.index = Constant.INT_ONE;
                      homeController.update();
                    },
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
                        buttonTitle: "إرسال طلب تبرع",
                        height: Constant.customButtonHeight / 1.5,
                        textColor: AppTheme.colorWhite,
                        onTap: () async {
                          Future deleteDonation() async {
                            CollectionReference donationRequestRef =
                                FirebaseFirestore.instance.collection('freeDonationRequest');

                            DateTime now = DateTime.now();
                            Timestamp currentTimestamp = Timestamp.fromDate(now);

                            try {
                              donationRequestRef.add({
                                'status': 'panding',
                                'userUid': userId,
                                'userName': userName,
                                'userEmail': userEmail,
                                'userBloodType': userBloodType,
                                'userAge': userAge,
                                'userWeight': userWeight,
                                'userHeight': userHeight,
                                'userChronicDiseases': userChronicDiseases,
                                'time': currentTimestamp,
                                'hospitalUID': hospitalSelectedUid,
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 3),
                                  showCloseIcon: true,
                                  content: Text("تم إرسال طلب التبرع بنجاح "),
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
                  ),
                  SizedBox(
                    height: height * Constant.searchBodyHeight,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('hospitals')
                          .doc(documentId)
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
                          // عرض قائمة الأماكن السياحية
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
                              String hospitalUid = data['hospitalUid'];
                              String documentDetailuid = document.id;

                              DateTime now2 = data['date']?.toDate() ?? DateTime.now();
                              DateFormat formatter2 = DateFormat.yMd().add_jm();
                              String date = formatter2.format(now2);

                              return Stack(
                                children: [
                                  // تأثير زجاجي خلفي للعنصر
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: Constant.blurSigmaX, sigmaY: Constant.blurSigmaY),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // إخفاء لوحة المفاتيح عند النقر على العنصر
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(Constant.searchTileMargin),
                                      padding: const EdgeInsets.only(bottom: Constant.searchTileContentBottomPadding),
                                      decoration: Constant.boxDecoration,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // معلومات الأماكن السياحية
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                // عنوان الأماكن السياحية

                                                CustomText(
                                                  title: title,
                                                  fontSize: Constant.searchTileTitleSize,
                                                  color: AppTheme.colorblack,
                                                  fontWight: FontWeight.w900,
                                                ),
                                                // عنوان التفاصيل والموقع
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.8,
                                                    child: CustomText(
                                                      title: "وصف الطلب : $description",
                                                      fontSize: width * 0.04,
                                                      color: AppTheme.tripCardLocationColor,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.8,
                                                    child: CustomText(
                                                      title: "نوع الفصيلة : $bloodGroups",
                                                      fontSize: width * 0.04,
                                                      color: AppTheme.tripCardLocationColor,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.8,
                                                    child: CustomText(
                                                      title: "كمية الاحتياج : $numberDonorsRequired متبرع",
                                                      fontSize: width * 0.04,
                                                      color: AppTheme.tripCardLocationColor,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.8,
                                                    child: CustomText(
                                                      title: "ميعاد التبرع : $date",
                                                      fontSize: width * 0.04,
                                                      color: AppTheme.tripCardLocationColor,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                numberDonorsRequired != 0
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                                        child: SizedBox(
                                                          width: width * 0.7,
                                                          child: CustomButton(
                                                            backgroundColor: AppTheme.themeColor,
                                                            borderColor: AppTheme.themeColor,
                                                            // width: 50,
                                                            buttonTitle: "طلب تبرع",
                                                            height: Constant.customButtonHeight / 1.5,
                                                            textColor: AppTheme.colorWhite,
                                                            onTap: () async {
                                                              Future payTickets() async {
                                                                String ticketId =
                                                                    generateRandomNumber(); // توليد رقم عشوائي لتذكرة

                                                                CollectionReference mainTickets = FirebaseFirestore
                                                                    .instance
                                                                    .collection('userDonationRequestWithHospital');

                                                                DateTime now = DateTime.now();
                                                                Timestamp currentTimestamp = Timestamp.fromDate(now);

                                                                mainTickets.add({
                                                                  'status': 'panding',
                                                                  'userUid': userId,
                                                                  'userName': userName,
                                                                  'userEmail': userEmail,
                                                                  'title': title,
                                                                  'description': description,
                                                                  'bloodGroups': bloodGroups,
                                                                  'userBloodType': userBloodType,
                                                                  'userAge': userAge,
                                                                  'userWeight': userWeight,
                                                                  'userHeight': userHeight,
                                                                  'userChronicDiseases': userChronicDiseases,
                                                                  'ticketId': ticketId,
                                                                  'donationDeadline': date,
                                                                  'time': currentTimestamp,
                                                                  'hospitalUID': hospitalSelectedUid,
                                                                });
                                                              }

                                                              payTickets();
                                                              try {
                                                                // استدعاء Firestore لتحديث الحقل "like"
                                                                await FirebaseFirestore.instance
                                                                    .collection('cities')
                                                                    .doc(documentId)
                                                                    .collection('events')
                                                                    .doc(documentDetailId)
                                                                    .update({
                                                                  'totalTicketsAvailable': FieldValue.increment(-1)
                                                                });
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  const SnackBar(
                                                                    duration: Duration(seconds: 3),
                                                                    showCloseIcon: true,
                                                                    content: Text("تم شراء التذكرة بنجاح"),
                                                                  ),
                                                                );
                                                              } catch (e) {
                                                                print('حدث خطأ: $e');
                                                              }
                                                              setState(() {});
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                const SnackBar(
                                                                  duration: Duration(seconds: 10),
                                                                  showCloseIcon: true,
                                                                  content: Text(
                                                                      "تم تقديم طلب التبرع سيتم ارسال رساله على البريد المسجل لدينا بالقبول او الرفض"),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
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
    );
  }

  buildSlider() {
    // يُنشئ ويعين مظهر العنصر
    return Container(
      padding: const EdgeInsets.only(left: 20),
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // تحديد اتجاه التمرير (أفقي)
        primary: false,
        itemCount: places == null ? 0 : places.length, // عدد العناصر في القائمة
        itemBuilder: (BuildContext context, int index) {
          Map place = places[index]; // استخراج العنصر الحالي من القائمة

          // بناء عنصر قائمة الصور
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                "${place["img"]}", // استخدام اسم الملف للصورة
                height: 250.0,
                width: MediaQuery.of(context).size.width - 40.0,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  bottomNavBar() {
    // يُنشئ ويعين مظهر شريط التنقل السفلي
    return Align(
      alignment: Alignment.bottomCenter, // تحديد موقع شريط التنقل في الجزء السفلي من الشاشة
      child: Padding(
        padding: const EdgeInsets.all(Constant.bottomNavigationBarPadding),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.colorWhite, // لون خلفية شريط التنقل
            boxShadow: [Constant.boxShadow(color: AppTheme.greyColor)], // إضافة ظل باستخدام boxShadow
            borderRadius: BorderRadius.circular(Constant.bottomNavigationBarRadius), // تحديد زوايا مستديرة للحاوية
          ),
          padding: const EdgeInsets.only(left: Constant.bottomBarLeftPadding, right: Constant.bottomBarRightPadding),
          width: width, // تعيين عرض شريط التنقل بناءً على عرض الشاشة
          height: height * Constant.bottomBarHeight / 1.2, // تحديد ارتفاع شريط التنقل
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navBarItem(title: Strings.home, index: Constant.INT_ONE, icon: home, tappedIcon: tapHome),
              if (userRole == 'user')
                navBarItem(title: Strings.profile, index: Constant.INT_TWO, icon: person, tappedIcon: tapPerson),
              if (userRole == 'hospital')
                navBarItem(title: Strings.yourDonations, index: Constant.INT_TWO, icon: person, tappedIcon: tapPerson),
              navBarItem(title: Strings.donations, index: Constant.INT_THREE, icon: chat, tappedIcon: tapChat),
            ],
          ),
        ),
      ),
    );
  }

  navBarItem({required int index, required String icon, required String tappedIcon, required String title}) {
    // InkWell: يُستخدم لإضافة تفاعل عند النقر على العنصر.
    return InkWell(
      onTap: () {
        homeController.index = index; // تحديد الفهرس عند النقر.
        homeController.update(); // تحديث حالة الواجهة بعد تغيير الفهرس.
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            // SvgPicture.asset: يُستخدم لعرض صور SVG من الملفات المحلية.
            homeController.index == index ? tappedIcon : icon, // اختيار أيقونة الزر بناءً على حالة الفهرس.
            height: Constant.bottomBarIconSize, // تحديد ارتفاع أيقونة الزر.
            width: Constant.bottomBarIconSize, // تحديد عرض أيقونة الزر.
            color: homeController.index == index ? AppTheme.themeColor : AppTheme.greyColor, // تحديد لون أيقونة الزر.
          ),
          CustomText(
            topPadding: Constant.bottomBarTitlePadding, // تحديد هامش أعلى لنص العنصر.
            title: title, // نص العنصر.
            fontSize: Constant.bottomBarTitleSize, // حجم الخط لنص العنصر.
            color: homeController.index == index ? AppTheme.themeColor : AppTheme.greyColor, // لون نص العنصر.
          )
        ],
      ),
    );
  }
}
