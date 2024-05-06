import 'dart:ui';

import 'package:blooddonation/pages/Connects/connects_controller.dart';
import 'package:blooddonation/webservices/firebase_data.dart';
import 'package:blooddonation/webservices/sendEmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/util/resources.dart';
import 'package:blooddonation/widgets/Custom_Textfield.dart';
import 'package:blooddonation/widgets/Custombutton.dart';
import 'package:blooddonation/widgets/_appbar.dart';
import 'package:blooddonation/widgets/connectTile.dart';
import 'package:blooddonation/widgets/custom_text.dart';
import 'package:blooddonation/widgets/no_appbar.dart';
import 'package:intl/intl.dart';

class DonationRequest extends StatefulWidget {
  const DonationRequest({super.key});

  @override
  State<DonationRequest> createState() => _DonationRequestState();
}

class _DonationRequestState extends State<DonationRequest> {
  double? height;
  double? width;

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
        });
      },
    );
  }

  Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance.collection('hospitals').doc(hospitalsId).collection('donationRequest').snapshots();
  final connectController = Get.put(ConnectController());
  final title = TextEditingController();
  final bloodType = TextEditingController();
  final date = TextEditingController();
  final description = TextEditingController();
  final numberDonorsRequired = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  addDonationRequest() async {
    // الحصول على معرف المستخدم المسجل دخوله
    CollectionReference donationRequestRef = FirebaseFirestore.instance.collection('hospitals');
    int parsedNumberDonorsRequired = int.parse(numberDonorsRequired.text);

    // إضافة الطلب إلى مجموعة donationRequest داخل hospitals
    await donationRequestRef.doc(hospitalsId).collection('donationRequest').add({
      "title": title.text,
      'date': _selectedDate,
      'bloodGroups': bloodType.text,
      'hospitalUid': userId,
      'numberDonorsRequired': parsedNumberDonorsRequired,
      'description': description.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        showCloseIcon: true,
        content: Text("تم إضافة طلب التبرع للمتبرعين بنجاح"),
      ),
    );
    connectController.index = Constant.INT_ONE;
    connectController.update();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // يتم استخدام GetBuilder للتحكم في حالة الـ ConnectController
    return GetBuilder(
        init: connectController,
        builder: (_) {
          return Scaffold(body: _body());
        });
  }

  // دالة تقوم بإرجاع الجزء الرئيسي للصفحة
  _body() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Builder(builder: (context) {
            // يتم استخدام switch لتحديد الجزء الذي يتم عرضه على الشاشة
            switch (connectController.index) {
              case Constant.INT_ONE:
                return __body();
              case Constant.INT_TWO:
                return _addOrder();

              case Constant.INT_THREE:
                return allUserDonationRequests();
              case Constant.INT_FOUR:
                return _allHospitalDonationRequests();
              case Constant.INT_FIVE:
                return userDonationsRequests();
              case Constant.INT_SIX:
                return userDonationWishes();
              case Constant.INT_Seventh:
                return userRequestsDonationWishes();

              default:
                return __body();
            }
          }),
        ],
      ),
    );
  }

  // دالة لعرض الجزء الأول من الشاشة
  __body() {
    return Center(
      child: userRole == 'user'
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // عناصر لتحديد الخيارات المتاحة للمستخدم
                optionBox(
                    icon: superLeads,
                    title: Strings.userwishes,
                    onTap: () {
                      connectController.index = Constant.INT_Seventh;
                      connectController.update();
                    }),
                optionBox(
                    icon: superLeads,
                    title: Strings.userOrder,
                    onTap: () {
                      connectController.index = Constant.INT_FIVE;
                      connectController.update();
                    }),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                optionBox(
                    icon: superLeads,
                    title: Strings.donationWishes,
                    onTap: () {
                      connectController.index = Constant.INT_SIX;
                      connectController.update();
                    }),
                optionBox(
                    icon: superLeads,
                    title: Strings.allOrder,
                    onTap: () {
                      connectController.index = Constant.INT_THREE;
                      connectController.update();
                    }),
                optionBox(
                    icon: group,
                    title: Strings.donationRequest,
                    onTap: () {
                      connectController.index = Constant.INT_TWO;
                      connectController.update();
                    })
              ],
            ),
    );
  }

  // دالة لعرض الجزء المتعلق بإضافة تجربة جديدة
  _addOrder() {
    // بناء واجهة Scaffold
    return Scaffold(
      backgroundColor: AppTheme.connectBodyColor,
      appBar: NoAppBar(), // إزالة الشريط العلوي للتطبيق
      body: SingleChildScrollView(
        // عنصر يمكن التمرير داخله
        child: Padding(
          // إضافة تباعد للأطراف
          padding: const EdgeInsets.only(
            left: Constant.bookingTileLeftPadding, // تحديد تباعد من اليسار
            right: Constant.bookingTileRightPadding, // تحديد تباعد من اليمين
          ),
          child: Column(
            // عنصر يتسع للعمود
            children: [
              Padding(
                // إضافة تباعد للأطراف داخل العنصر
                padding: Constant.constantPadding(Constant.SIZE100 / 2), // حساب التباعد بناءً على الحجم المعطى
                child: CustomAppBar(
                  // بناء شريط عنوان مخصص
                  leftPadding: 15, // تحديد تباعد من اليسار
                  bottomPadding: 10, // تحديد تباعد من الأسفل
                  title: Strings.allOrder, // تحديد عنوان الشريط
                  space: Constant.SIZE15, // تحديد المسافة بين العناصر
                  onTap: () {
                    // إضافة تفاعل عند النقر
                    connectController.index = Constant.INT_ONE; // تحديث حالة متحكم الاتصال
                    connectController.update(); // تحديث واجهة المستخدم
                  },
                ),
              ),
              Container(
                // بناء عنصر من نوع حاوية
                color: AppTheme.loginPageColor, // تحديد لون الخلفية
                height: height, // تحديد الارتفاع
                width: width, // تحديد العرض
                child: SingleChildScrollView(
                  // عنصر يمكن التمرير داخله
                  child: Form(
                    // إنشاء نموذج
                    key: _formKey, // تحديد مفتاح النموذج
                    child: Column(
                      // عنصر يتسع للعمود
                      children: [
                        const SizedBox(
                          // إضافة تباعد بين العناصر
                          height: 22, // تحديد الارتفاع
                        ),
                        // واجهات إدخال لإدخال بيانات التجربة
                        CustomTextFeild(
                          // بناء حقل نصي مخصص
                          controller: title, // تحديد متحكم الحقل
                          hintText: "العنوان :", // تحديد نص التلميح
                          hintSize: 16, // تحديد حجم نص التلميح
                          contentRightPadding: 10, // تحديد تباعد الحاوية الداخلية من اليمين
                          onTap: () {}, // إضافة تفاعل عند النقر
                          onChanged: (newValue) => newValue, // استدعاء دالة عندما يتم تغيير القيمة
                        ),

                        CustomTextFeild(
                          controller: bloodType,
                          hintText: "نوع الفصيلة :",
                          hintSize: 16,
                          contentRightPadding: 10,
                          onTap: () {},
                          onChanged: (newValue) => newValue,
                        ),
                        CustomTextFeild(
                          controller: description,
                          hintText: "الشروط :",
                          hintSize: 16,
                          contentRightPadding: 10,
                          onTap: () {},
                          onChanged: (newValue) => newValue,
                        ),
                        CustomTextFeild(
                          controller: numberDonorsRequired,
                          hintText: "عدد المتبرعين المطلوب :",
                          hintSize: 16,
                          contentRightPadding: 10,
                          onTap: () {},
                          onChanged: (newValue) => newValue,
                        ),
                        const SizedBox(
                          // إضافة تباعد بين العناصر
                          height: 22, // تحديد الارتفاع
                        ),
                        SizedBox(
                          // حاوية للزر المرتفع
                          width: 240, // تحديد العرض
                          child: ElevatedButton(
                              // بناء زر مرتفع
                              style: ElevatedButton.styleFrom(
                                // تحديد سمات الزر
                                backgroundColor: AppTheme.colorRed, // تحديد لون الخلفية
                              ),
                              child: const Text('تحديد موعد التبرع'), // إضافة نص للزر
                              onPressed: () async {
                                // إضافة تفاعل عند النقر
                                // Show the date picker
                                DateTime? selectedDate = await showDatePicker(
                                  // عرض المنتقى التاريخ
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                // Update the selected date
                                setState(() {
                                  // تحديث الحالة
                                  _selectedDate = selectedDate ?? _selectedDate; // تحديد التاريخ المحدد أو السابق
                                });
                              }),
                        ),
                        // زر لإضافة التجربة
                        CustomButton(
                          // بناء زر مخصص
                          backgroundColor: AppTheme.customButtonBgColor, // تحديد لون الخلفية
                          borderColor: AppTheme.customButtonBgColor, // تحديد لون الحدود
                          buttonTitle: Strings.add, // تحديد نص الزر
                          height: Constant.customButtonHeight, // تحديد الارتفاع
                          onTap: () async {
                            // إضافة تفاعل عند النقر
                            // Update the selected date
                            addDonationRequest(); // استدعاء دالة إضافة طلب التبرع
                          },
                          textColor: AppTheme.colorWhite, // تحديد لون النص
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  allUserDonationRequests() {
    // تحديد الارتفاع والعرض باستخدام MediaQuery
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // بناء واجهة Scaffold
    return Scaffold(
      backgroundColor: AppTheme.colorTransprant, // تحديد لون الخلفية
      appBar: NoAppBar(), // إزالة شريط العنوان
      body: Padding(
        // إضافة تباعد للأطراف
        padding: const EdgeInsets.only(
          left: Constant.bookingTileLeftPadding, // تحديد تباعد من اليسار
          right: Constant.bookingTileRightPadding, // تحديد تباعد من اليمين
        ),
        child: SingleChildScrollView(
          // عنصر يمكن التمرير داخله
          physics: const AlwaysScrollableScrollPhysics(), // تحديد خصائص السكروب
          child: Padding(
            // إضافة تباعد للأطراف
            padding: Constant.constantPadding(Constant.SIZE100 / 2), // حساب التباعد بناءً على الحجم المعطى
            child: Padding(
              // إضافة تباعد للأطراف
              padding: const EdgeInsets.only(bottom: 300), // تحديد تباعد من الأسفل
              child: Column(
                // عنصر يتسع للعمود
                children: [
                  // شريط العنوان
                  CustomAppBar(
                    title: "كل طلبات المتبرعين", // تحديد عنوان الشريط
                    space: Constant.SIZE15, // تحديد المسافة بين العناصر
                    leftPadding: 15, // تحديد تباعد من اليسار
                    bottomPadding: 10, // تحديد تباعد من الأسفل
                    onTap: () {
                      // إضافة تفاعل عند النقر
                      // تحديث حالة التطبيق
                      connectController.index = Constant.INT_ONE;
                      connectController.update();
                    },
                  ),
                  SizedBox(
                    // حاوية لعنصر يتسع للارتفاع المحدد
                    height: height! * Constant.searchBodyHeight, // تحديد الارتفاع
                    child: StreamBuilder<QuerySnapshot>(
                      // بناء بنية يستجيبة للبيانات المتدفقة
                      stream: FirebaseFirestore.instance
                          .collection('userDonationRequestWithHospital')
                          .where('hospitalUID', isEqualTo: userId)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          // التعامل مع حالة وجود خطأ
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // التعامل مع حالة الانتظار
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          // عرض القائمة عند وجود البيانات
                          return ListView.builder(
                            padding: EdgeInsets.only(
                              left: Constant.searchTileListLeftPadding, // تحديد تباعد من اليسار
                              bottom: height! * Constant.searchTileListBottomPadding, // تحديد تباعد من الأسفل
                              right: Constant.searchTileListRightPadding, // تحديد تباعد من اليمين
                              top: Constant.searchTileListTopPadding, // تحديد تباعد من الأعلى
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = snapshot.data!.docs[index]; // الوثيقة الحالية
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>; // البيانات كمصفوفة
                              // استخراج البيانات من الوثيقة
                              String title = data['title'];
                              String bloodGroups = data['bloodGroups'];
                              String description = data['description'];
                              String ticketId = data['ticketId'];
                              String userName = data['userName'];
                              String userEmail = data['userEmail'];
                              String userWeight = data['userWeight'];
                              String userHeight = data['userHeight'];
                              String userAge = data['userAge'];
                              String userBloodType = data['userBloodType'];
                              String userChronicDiseases = data['userChronicDiseases'];
                              String status = data['status'];
                              String donationDeadline = data['donationDeadline'];
                              String documentDetailuid = document.id; // معرف الوثيقة

                              // تحويل التاريخ لنص
                              DateTime now2 = data['time']?.toDate() ?? DateTime.now();
                              DateFormat formatter2 = DateFormat.yMd().add_jm();
                              String time = formatter2.format(now2);

                              return Stack(
                                // تراص العناصر
                                children: [
                                  // تأثير زجاجي خلفي
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: Constant.blurSigmaX,
                                        sigmaY: Constant.blurSigmaY), // تحديد مستوى التأثير
                                  ),
                                  InkWell(
                                    // عنصر تفاعلي
                                    onTap: () {
                                      FocusScope.of(context).unfocus(); // إخفاء لوحة المفاتيح عند النقر
                                    },
                                    child: Container(
                                      // حاوية للعناصر
                                      margin: const EdgeInsets.all(Constant.searchTileMargin), // تحديد تباعد الحاوية
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              Constant.searchTileContentBottomPadding), // تحديد تباعد الحاوية الداخلي
                                      decoration: Constant.boxDecoration, // تحديد تزيين الحاوية
                                      child: Row(
                                        // عنصر يمتد على الأفق
                                        crossAxisAlignment: CrossAxisAlignment.start, // تحديد توجيه العناصر
                                        children: [
                                          Padding(
                                            // إضافة تباعد للأطراف
                                            padding: const EdgeInsets.only(right: 8.0), // تحديد تباعد من اليمين
                                            child: Column(
                                              // عنصر يمتد على الرأس
                                              mainAxisAlignment: MainAxisAlignment.start, // تحديد توجيه العناصر
                                              crossAxisAlignment: CrossAxisAlignment.start, // تحديد توجيه العناصر
                                              children: [
                                                const SizedBox(
                                                  // إضافة تباعد بين العناصر
                                                  height: 20, // تحديد الارتفاع
                                                ),
                                                // عنوان الطلب
                                                CustomText(
                                                  title: title, // تحديد العنوان
                                                  fontSize: Constant.searchTileTitleSize, // تحديد حجم الخط
                                                  color: AppTheme.colorblack, // تحديد لون النص
                                                  fontWight: FontWeight.w900, // تحديد وزن الخط
                                                ),
                                                // وصف الطلب
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: Constant.tripCardLocationPadding), // تحديد تباعد من الأعلى
                                                  child: SizedBox(
                                                    // حاوية للعنصر
                                                    width: width! * 0.7, // تحديد العرض
                                                    child: CustomText(
                                                      // عنصر نصي مخصص
                                                      title: "وصف الطلب : $description", // تحديد النص
                                                      fontSize: width! * 0.03, // تحديد حجم الخط
                                                      textAlign: TextAlign.right, // تحديد محاذاة النص
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                      fontWight: FontWeight.w400, // تحديد وزن الخط
                                                    ),
                                                  ),
                                                ),
                                                // رقم الطلب
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: Constant.tripCardLocationPadding), // تحديد تباعد من الأعلى
                                                  child: SizedBox(
                                                    // حاوية للعنصر
                                                    width: width! * 0.7, // تحديد العرض
                                                    child: CustomText(
                                                      // عنصر نصي مخصص
                                                      title: "رقم الطلب : $ticketId", // تحديد النص
                                                      fontSize: width! * 0.03, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                      fontWight: FontWeight.w400, // تحديد وزن الخط
                                                    ),
                                                  ),
                                                ),
                                                // نوع الفصيلة المطلوبة
                                                SizedBox(
                                                  // حاوية للعنصر
                                                  width: width! * 0.75, // تحديد العرض
                                                  child: Text(
                                                    // عنصر نصي عادي
                                                    "نوع الفصيلة المطلوبة : $bloodGroups", // تحديد النص
                                                    style: TextStyle(
                                                      // تحديد السمات
                                                      fontSize: width! * 0.03, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                    ),
                                                  ),
                                                ),
                                                // ميعاد تقديم التبرع
                                                SizedBox(
                                                  // حاوية للعنصر
                                                  width: width! * 0.75, // تحديد العرض
                                                  child: Text(
                                                    // عنصر نصي عادي
                                                    "ميعاد تقديم المستخدم على التبرع : $time", // تحديد النص
                                                    style: TextStyle(
                                                      // تحديد السمات
                                                      fontSize: width! * 0.03, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                    ),
                                                  ),
                                                ),
                                                // ميعاد التبرع
                                                Text(
                                                  // عنصر نصي عادي
                                                  "ميعاد التبرع : $donationDeadline", // تحديد النص
                                                  style: TextStyle(
                                                    // تحديد السمات
                                                    fontSize: width! * 0.03, // تحديد حجم الخط
                                                    color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                  ),
                                                ),
                                                Text(
                                                  // عنصر نصي عادي
                                                  "فصيلة المقدم : $userBloodType", // تحديد النص
                                                  style: TextStyle(
                                                    // تحديد السمات
                                                    fontSize: width! * 0.03, // تحديد حجم الخط
                                                    color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                  ),
                                                ),
                                                Text(
                                                  // عنصر نصي عادي
                                                  "الأمراض : $userChronicDiseases", // تحديد النص
                                                  style: TextStyle(
                                                    // تحديد السمات
                                                    fontSize: width! * 0.03, // تحديد حجم الخط
                                                    color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                  ),
                                                ),
                                                Text(
                                                  // عنصر نصي عادي
                                                  "الوزن : $userWeight | الطول : $userHeight | عمر المقدم : $userAge", // تحديد النص
                                                  style: TextStyle(
                                                    // تحديد السمات
                                                    fontSize: width! * 0.03, // تحديد حجم الخط
                                                    color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                  ),
                                                ),

                                                status == 'panding' // التحقق من حالة الطلب
                                                    ? Padding(
                                                        // إضافة تباعد للأطراف
                                                        padding: const EdgeInsets.all(8.0), // تحديد تباعد
                                                        child: Row(
                                                          // عنصر يمتد على الأفق
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center, // تحديد توجيه العناصر
                                                          children: [
                                                            SizedBox(
                                                              // حاوية للزر
                                                              width: width! * 0.4, // تحديد العرض
                                                              child: CustomButton(
                                                                // زر مخصص
                                                                backgroundColor: Colors.green, // تحديد لون الخلفية
                                                                borderColor: const Color.fromARGB(
                                                                    255, 46, 155, 50), // تحديد لون الحدود
                                                                buttonTitle: "قبول الطلب", // تحديد نص الزر
                                                                height:
                                                                    Constant.customButtonHeight / 1.5, // تحديد الارتفاع
                                                                textColor: AppTheme.colorWhite, // تحديد لون النص
                                                                onTap: () async {
                                                                  // إضافة تفاعل عند النقر
                                                                  Future accepteDonation() async {
                                                                    // دالة لقبول الطلب
                                                                    Future appointmentsAccepted() async {
                                                                      // دالة لتحديث حالة الطلب
                                                                      CollectionReference mainCollectionRef =
                                                                          FirebaseFirestore.instance.collection(
                                                                              'userDonationRequestWithHospital');
                                                                      DocumentReference documentRef =
                                                                          mainCollectionRef.doc(documentDetailuid);

                                                                      documentRef.update({
                                                                        'status': 'Accepted', // تحديث الحالة
                                                                      });
                                                                    }

                                                                    appointmentsAccepted(); // تحديث الحالة
                                                                    sendEmail(
                                                                      // إرسال رسالة بالبريد الإلكتروني
                                                                      userEmail, // البريد الإلكتروني
                                                                      "مرحباً بك يا :: $userName لديك رساله من تطبيق Blood Donation", // عنوان الرسالة
                                                                      " تم  قبول طلب تبرعك فى   $title بتاريخ ${DateTime.now()}", // نص الرسالة
                                                                    );

                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      // إظهار رسالة منبثقة
                                                                      const SnackBar(
                                                                        duration: Duration(seconds: 3), // مدة الظهور
                                                                        showCloseIcon: true, // عرض أيقونة إغلاق
                                                                        content: Text(
                                                                            "تم قبول طلب التبرع بنجاح وسيتم اشعار المتبرع عبر البريد الإليكترونى الخاص بة "), // نص الرسالة
                                                                      ),
                                                                    );
                                                                  }

                                                                  accepteDonation(); // استدعاء دالة قبول الطلب
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              // حاوية للزر
                                                              width: width! * 0.4, // تحديد العرض
                                                              child: CustomButton(
                                                                // زر مخصص
                                                                backgroundColor:
                                                                    AppTheme.themeColor, // تحديد لون الخلفية
                                                                borderColor: AppTheme.themeColor, // تحديد لون الحدود
                                                                buttonTitle: "رفض الطلب", // تحديد نص الزر
                                                                height:
                                                                    Constant.customButtonHeight / 1.5, // تحديد الارتفاع
                                                                textColor: AppTheme.colorWhite, // تحديد لون النص
                                                                onTap: () async {
                                                                  // إضافة تفاعل عند النقر
                                                                  Future deleteDonation() async {
                                                                    // دالة لرفض الطلب
                                                                    Future appointmentsAccepted() async {
                                                                      // دالة لحذف الطلب
                                                                      CollectionReference mainCollectionRef =
                                                                          FirebaseFirestore.instance.collection(
                                                                              'userDonationRequestWithHospital');
                                                                      DocumentReference documentRef =
                                                                          mainCollectionRef.doc(documentDetailuid);

                                                                      await documentRef.delete(); // حذف الوثيقة
                                                                    }

                                                                    appointmentsAccepted(); // استدعاء دالة حذف الطلب
                                                                    sendEmail(
                                                                      // إرسال رسالة بالبريد الإلكتروني
                                                                      userEmail, // البريد الإلكتروني
                                                                      "مرحباً بك يا :: $userName لديك رساله من تطبيق Blood Donation", // عنوان الرسالة
                                                                      " تم رفض طلب تبرعك فى $title بتاريخ ${DateTime.now()}", // نص الرسالة
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      // إظهار رسالة منبثقة
                                                                      const SnackBar(
                                                                        duration: Duration(seconds: 3), // مدة الظهور
                                                                        showCloseIcon: true, // عرض أيقونة إغلاق
                                                                        content: Text(
                                                                            "تم رفض طلب التبرع وسيتم اشعار المتبرع عبر البريد الإليكترونى الخاص بة "), // نص الرسالة
                                                                      ),
                                                                    );
                                                                  }

                                                                  deleteDonation(); // استدعاء دالة رفض الطلب
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Padding(
                                                        // إضافة تباعد للأطراف
                                                        padding: const EdgeInsets.all(8.0), // تحديد تباعد
                                                        child: SizedBox(
                                                          // حاوية للزر
                                                          width: width! * 0.8, // تحديد العرض
                                                          child: CustomButton(
                                                            // زر مخصص
                                                            backgroundColor: AppTheme.themeColor, // تحديد لون الخلفية
                                                            borderColor: AppTheme.themeColor, // تحديد لون الحدود
                                                            buttonTitle: "إلغاء قبول الطلب", // تحديد نص الزر
                                                            height: Constant.customButtonHeight / 1.5, // تحديد الارتفاع
                                                            textColor: AppTheme.colorWhite, // تحديد لون النص
                                                            onTap: () async {
                                                              // إضافة تفاعل عند النقر
                                                              Future deleteDonation() async {
                                                                // دالة لإلغاء قبول الطلب
                                                                Future appointmentsAccepted() async {
                                                                  // دالة لحذف الطلب
                                                                  CollectionReference mainCollectionRef =
                                                                      FirebaseFirestore.instance.collection(
                                                                          'userDonationRequestWithHospital');
                                                                  DocumentReference documentRef =
                                                                      mainCollectionRef.doc(documentDetailuid);

                                                                  await documentRef.delete(); // حذف الوثيقة
                                                                }

                                                                appointmentsAccepted(); // استدعاء دالة حذف الطلب
                                                                sendEmail(
                                                                  // إرسال رسالة بالبريد الإلكتروني
                                                                  userEmail, // البريد الإلكتروني
                                                                  "مرحباً بك يا :: $userName لديك رساله من تطبيق Blood Donation", // عنوان الرسالة
                                                                  " تم إلغاء قبول طلب تبرعك فى $title بتاريخ ${DateTime.now()} نعتذر ", // نص الرسالة
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  // إظهار رسالة منبثقة
                                                                  const SnackBar(
                                                                    duration: Duration(seconds: 3), // مدة الظهور
                                                                    showCloseIcon: true, // عرض أيقونة إغلاق
                                                                    content: Text(
                                                                        "تم إلغاء قبول طلب التبرع وسيتم اشعار المتبرع عبر البريد الإليكترونى الخاص بة "), // نص الرسالة
                                                                  ),
                                                                );
                                                              }

                                                              deleteDonation(); // استدعاء دالة إلغاء قبول الطلب
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                // زر "المزيد"
                                                // InkWell(
                                                //   onTap: () async {
                                                //     // عرض تفاصيل المزيد
                                                //     homeController.index = Constant.INT_SIX;
                                                //     homeController.update();
                                                //     setState(() {
                                                //       documentDetailId = documentDetailuid;
                                                //     });
                                                //   },
                                                //   child: CustomText(
                                                //     topPadding: Constant.moreTextTopPadding,
                                                //     title: Strings.more,
                                                //     fontSize: Constant.moreTextSize,
                                                //     fontfamily: Strings.emptyString,
                                                //     color: AppTheme.themeColor,
                                                //     fontWight: FontWeight.w400,
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
                    // إضافة تباعد بين العناصر
                    height: 200, // تحديد الارتفاع
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  userDonationWishes() {
    // تحديد الارتفاع والعرض باستخدام MediaQuery
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // بناء واجهة Scaffold
    return Scaffold(
      backgroundColor: AppTheme.colorTransprant, // تحديد لون الخلفية
      appBar: NoAppBar(), // إزالة شريط العنوان
      body: Padding(
        // إضافة تباعد للأطراف
        padding: const EdgeInsets.only(
          left: Constant.bookingTileLeftPadding, // تحديد تباعد من اليسار
          right: Constant.bookingTileRightPadding, // تحديد تباعد من اليمين
        ),
        child: SingleChildScrollView(
          // عنصر يمكن التمرير داخله
          physics: const AlwaysScrollableScrollPhysics(), // تحديد خصائص السكروب
          child: Padding(
            // إضافة تباعد للأطراف
            padding: Constant.constantPadding(Constant.SIZE100 / 2), // حساب التباعد بناءً على الحجم المعطى
            child: Padding(
              // إضافة تباعد للأطراف
              padding: const EdgeInsets.only(bottom: 300), // تحديد تباعد من الأسفل
              child: Column(
                // عنصر يتسع للعمود
                children: [
                  // شريط العنوان
                  CustomAppBar(
                    title: "رغبات المتبرعين فى التبرع", // تحديد عنوان الشريط
                    space: Constant.SIZE15, // تحديد المسافة بين العناصر
                    leftPadding: 15, // تحديد تباعد من اليسار
                    bottomPadding: 10, // تحديد تباعد من الأسفل
                    onTap: () {
                      // إضافة تفاعل عند النقر
                      // تحديث حالة التطبيق
                      connectController.index = Constant.INT_ONE;
                      connectController.update();
                    },
                  ),
                  SizedBox(
                    // حاوية لعنصر يتسع للارتفاع المحدد
                    height: height! * Constant.searchBodyHeight, // تحديد الارتفاع
                    child: StreamBuilder<QuerySnapshot>(
                      // بناء بنية يستجيبة للبيانات المتدفقة
                      stream: FirebaseFirestore.instance
                          .collection('freeDonationRequest')
                          .where('hospitalUID', isEqualTo: userId)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          // التعامل مع حالة وجود خطأ
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // التعامل مع حالة الانتظار
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          // عرض القائمة عند وجود البيانات
                          return ListView.builder(
                            padding: EdgeInsets.only(
                              left: Constant.searchTileListLeftPadding, // تحديد تباعد من اليسار
                              bottom: height! * Constant.searchTileListBottomPadding, // تحديد تباعد من الأسفل
                              right: Constant.searchTileListRightPadding, // تحديد تباعد من اليمين
                              top: Constant.searchTileListTopPadding, // تحديد تباعد من الأعلى
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = snapshot.data!.docs[index]; // الوثيقة الحالية
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>; // البيانات كمصفوفة
                              // استخراج البيانات من الوثيقة
                              String userName = data['userName'];
                              String userEmail = data['userEmail'];
                              String hospitalUID = data['hospitalUID'];
                              String userBloodType = data['userBloodType'];
                              String userChronicDiseases = data['userChronicDiseases'];
                              String userHeight = data['userHeight'];
                              String userWeight = data['userWeight'];
                              String status = data['status'];
                              String documentDetailuid = document.id; // معرف الوثيقة

                              // تحويل التاريخ لنص
                              DateTime now2 = data['time']?.toDate() ?? DateTime.now();
                              DateFormat formatter2 = DateFormat.yMd().add_jm();
                              String time = formatter2.format(now2);

                              return Stack(
                                // تراص العناصر
                                children: [
                                  // تأثير زجاجي خلفي
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: Constant.blurSigmaX,
                                        sigmaY: Constant.blurSigmaY), // تحديد مستوى التأثير
                                  ),
                                  InkWell(
                                    // عنصر تفاعلي
                                    onTap: () {
                                      FocusScope.of(context).unfocus(); // إخفاء لوحة المفاتيح عند النقر
                                    },
                                    child: Container(
                                      // حاوية للعناصر
                                      margin: const EdgeInsets.all(Constant.searchTileMargin), // تحديد تباعد الحاوية
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              Constant.searchTileContentBottomPadding), // تحديد تباعد الحاوية الداخلي
                                      decoration: Constant.boxDecoration, // تحديد تزيين الحاوية
                                      child: Row(
                                        // عنصر يمتد على الأفق
                                        crossAxisAlignment: CrossAxisAlignment.start, // تحديد توجيه العناصر
                                        children: [
                                          Padding(
                                            // إضافة تباعد للأطراف
                                            padding: const EdgeInsets.only(right: 8.0), // تحديد تباعد من اليمين
                                            child: Column(
                                              // عنصر يمتد على الرأس
                                              mainAxisAlignment: MainAxisAlignment.start, // تحديد توجيه العناصر
                                              crossAxisAlignment: CrossAxisAlignment.start, // تحديد توجيه العناصر
                                              children: [
                                                const SizedBox(
                                                  // إضافة تباعد بين العناصر
                                                  height: 20, // تحديد الارتفاع
                                                ),
                                                // عنوان الطلب
                                                CustomText(
                                                  title: 'إسم المتبرع $userName', // تحديد العنوان
                                                  fontSize: Constant.searchTileTitleSize, // تحديد حجم الخط
                                                  color: AppTheme.colorblack, // تحديد لون النص
                                                  fontWight: FontWeight.w900, // تحديد وزن الخط
                                                ),
                                                // وصف الطلب
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: Constant.tripCardLocationPadding), // تحديد تباعد من الأعلى
                                                  child: SizedBox(
                                                    // حاوية للعنصر
                                                    width: width! * 0.7, // تحديد العرض
                                                    child: CustomText(
                                                      // عنصر نصي مخصص
                                                      title: "بريد المتبرع : $userEmail", // تحديد النص
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      textAlign: TextAlign.right, // تحديد محاذاة النص
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                      fontWight: FontWeight.w400, // تحديد وزن الخط
                                                    ),
                                                  ),
                                                ),
                                                // رقم الطلب
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: Constant.tripCardLocationPadding), // تحديد تباعد من الأعلى
                                                  child: SizedBox(
                                                    // حاوية للعنصر
                                                    width: width! * 0.7, // تحديد العرض
                                                    child: CustomText(
                                                      // عنصر نصي مخصص
                                                      title: "فصيلة الدم : $userBloodType", // تحديد النص
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                      fontWight: FontWeight.w400, // تحديد وزن الخط
                                                    ),
                                                  ),
                                                ),
                                                // نوع الفصيلة المطلوبة
                                                SizedBox(
                                                  // حاوية للعنصر
                                                  width: width! * 0.75, // تحديد العرض
                                                  child: Text(
                                                    // عنصر نصي عادي
                                                    "الأمراض المزمنة : $userChronicDiseases", // تحديد النص
                                                    style: TextStyle(
                                                      // تحديد السمات
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                    ),
                                                  ),
                                                ),
                                                // ميعاد تقديم التبرع
                                                SizedBox(
                                                  // حاوية للعنصر
                                                  width: width! * 0.75, // تحديد العرض
                                                  child: Text(
                                                    // عنصر نصي عادي
                                                    "ميعاد تقديم الطلب : $time", // تحديد النص
                                                    style: TextStyle(
                                                      // تحديد السمات
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                    ),
                                                  ),
                                                ),

                                                Text(
                                                  // عنصر نصي عادي
                                                  "الطول : $userHeight | الوزن : $userWeight", // تحديد النص
                                                  style: TextStyle(
                                                    // تحديد السمات
                                                    fontSize: width! * 0.04, // تحديد حجم الخط
                                                    color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                  ),
                                                ),
                                                status == 'panding'
                                                    ? Text(
                                                        // عنصر نصي عادي
                                                        "جاري مراجعه الطلب", // تحديد النص
                                                        style: TextStyle(
                                                          // تحديد السمات
                                                          fontSize: width! * 0.04, // تحديد حجم الخط
                                                          color: Colors.blue, // تحديد لون النص
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                status == 'panding' // التحقق من حالة الطلب
                                                    ? Padding(
                                                        // إضافة تباعد للأطراف
                                                        padding: const EdgeInsets.all(8.0), // تحديد تباعد
                                                        child: Row(
                                                          // عنصر يمتد على الأفق
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center, // تحديد توجيه العناصر
                                                          children: [
                                                            SizedBox(
                                                              // حاوية للزر
                                                              width: width! * 0.4, // تحديد العرض
                                                              child: CustomButton(
                                                                // زر مخصص
                                                                backgroundColor: Colors.green, // تحديد لون الخلفية
                                                                borderColor: const Color.fromARGB(
                                                                    255, 46, 155, 50), // تحديد لون الحدود
                                                                buttonTitle: "قبول الطلب", // تحديد نص الزر
                                                                height:
                                                                    Constant.customButtonHeight / 1.5, // تحديد الارتفاع
                                                                textColor: AppTheme.colorWhite, // تحديد لون النص
                                                                onTap: () async {
                                                                  // إضافة تفاعل عند النقر
                                                                  Future accepteDonation() async {
                                                                    // دالة لقبول الطلب
                                                                    Future appointmentsAccepted() async {
                                                                      // دالة لتحديث حالة الطلب
                                                                      CollectionReference mainCollectionRef =
                                                                          FirebaseFirestore.instance
                                                                              .collection('freeDonationRequest');
                                                                      DocumentReference documentRef =
                                                                          mainCollectionRef.doc(documentDetailuid);

                                                                      documentRef.update({
                                                                        'status': 'Accepted', // تحديث الحالة
                                                                      });
                                                                    }

                                                                    appointmentsAccepted(); // تحديث الحالة
                                                                    sendEmail(
                                                                      // إرسال رسالة بالبريد الإلكتروني
                                                                      userEmail, // البريد الإلكتروني
                                                                      "مرحباً بك يا :: $userName لديك رساله من تطبيق Blood Donation", // عنوان الرسالة
                                                                      " تم  قبول طلب تبرعك فى   $title بتاريخ ${DateTime.now()}", // نص الرسالة
                                                                    );

                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      // إظهار رسالة منبثقة
                                                                      const SnackBar(
                                                                        duration: Duration(seconds: 3), // مدة الظهور
                                                                        showCloseIcon: true, // عرض أيقونة إغلاق
                                                                        content: Text(
                                                                            "تم قبول طلب التبرع بنجاح وسيتم اشعار المتبرع عبر البريد الإليكترونى الخاص بة "), // نص الرسالة
                                                                      ),
                                                                    );
                                                                  }

                                                                  accepteDonation(); // استدعاء دالة قبول الطلب
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              // حاوية للزر
                                                              width: width! * 0.4, // تحديد العرض
                                                              child: CustomButton(
                                                                // زر مخصص
                                                                backgroundColor:
                                                                    AppTheme.themeColor, // تحديد لون الخلفية
                                                                borderColor: AppTheme.themeColor, // تحديد لون الحدود
                                                                buttonTitle: "رفض الطلب", // تحديد نص الزر
                                                                height:
                                                                    Constant.customButtonHeight / 1.5, // تحديد الارتفاع
                                                                textColor: AppTheme.colorWhite, // تحديد لون النص
                                                                onTap: () async {
                                                                  // إضافة تفاعل عند النقر
                                                                  Future deleteDonation() async {
                                                                    // دالة لرفض الطلب
                                                                    Future appointmentsAccepted() async {
                                                                      // دالة لحذف الطلب
                                                                      CollectionReference mainCollectionRef =
                                                                          FirebaseFirestore.instance
                                                                              .collection('freeDonationRequest');
                                                                      DocumentReference documentRef =
                                                                          mainCollectionRef.doc(documentDetailuid);

                                                                      await documentRef.delete(); // حذف الوثيقة
                                                                    }

                                                                    appointmentsAccepted(); // استدعاء دالة حذف الطلب
                                                                    sendEmail(
                                                                      // إرسال رسالة بالبريد الإلكتروني
                                                                      userEmail, // البريد الإلكتروني
                                                                      "مرحباً بك يا :: $userName لديك رساله من تطبيق Blood Donation", // عنوان الرسالة
                                                                      " تم رفض طلب تبرعك فى $title بتاريخ ${DateTime.now()}", // نص الرسالة
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      // إظهار رسالة منبثقة
                                                                      const SnackBar(
                                                                        duration: Duration(seconds: 3), // مدة الظهور
                                                                        showCloseIcon: true, // عرض أيقونة إغلاق
                                                                        content: Text(
                                                                            "تم رفض طلب التبرع وسيتم اشعار المتبرع عبر البريد الإليكترونى الخاص بة "), // نص الرسالة
                                                                      ),
                                                                    );
                                                                  }

                                                                  deleteDonation(); // استدعاء دالة رفض الطلب
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Padding(
                                                        // إضافة تباعد للأطراف
                                                        padding: const EdgeInsets.all(8.0), // تحديد تباعد
                                                        child: SizedBox(
                                                          // حاوية للزر
                                                          width: width! * 0.8, // تحديد العرض
                                                          child: CustomButton(
                                                            // زر مخصص
                                                            backgroundColor: AppTheme.themeColor, // تحديد لون الخلفية
                                                            borderColor: AppTheme.themeColor, // تحديد لون الحدود
                                                            buttonTitle: "إلغاء قبول الطلب", // تحديد نص الزر
                                                            height: Constant.customButtonHeight / 1.5, // تحديد الارتفاع
                                                            textColor: AppTheme.colorWhite, // تحديد لون النص
                                                            onTap: () async {
                                                              // إضافة تفاعل عند النقر
                                                              Future deleteDonation() async {
                                                                // دالة لإلغاء قبول الطلب
                                                                Future appointmentsAccepted() async {
                                                                  // دالة لحذف الطلب
                                                                  CollectionReference mainCollectionRef =
                                                                      FirebaseFirestore.instance
                                                                          .collection('freeDonationRequest');
                                                                  DocumentReference documentRef =
                                                                      mainCollectionRef.doc(documentDetailuid);

                                                                  await documentRef.delete(); // حذف الوثيقة
                                                                }

                                                                appointmentsAccepted(); // استدعاء دالة حذف الطلب
                                                                sendEmail(
                                                                  // إرسال رسالة بالبريد الإلكتروني
                                                                  userEmail, // البريد الإلكتروني
                                                                  "مرحباً بك يا :: $userName لديك رساله من تطبيق Blood Donation", // عنوان الرسالة
                                                                  " تم إلغاء قبول طلب تبرعك فى $title بتاريخ ${DateTime.now()} نعتذر ", // نص الرسالة
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  // إظهار رسالة منبثقة
                                                                  const SnackBar(
                                                                    duration: Duration(seconds: 3), // مدة الظهور
                                                                    showCloseIcon: true, // عرض أيقونة إغلاق
                                                                    content: Text(
                                                                        "تم إلغاء قبول طلب التبرع وسيتم اشعار المتبرع عبر البريد الإليكترونى الخاص بة "), // نص الرسالة
                                                                  ),
                                                                );
                                                              }

                                                              deleteDonation(); // استدعاء دالة إلغاء قبول الطلب
                                                            },
                                                          ),
                                                        ),
                                                      )
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
                    // إضافة تباعد بين العناصر
                    height: 200, // تحديد الارتفاع
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  userRequestsDonationWishes() {
    // تحديد الارتفاع والعرض باستخدام MediaQuery
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // بناء واجهة Scaffold
    return Scaffold(
      backgroundColor: AppTheme.colorTransprant, // تحديد لون الخلفية
      appBar: NoAppBar(), // إزالة شريط العنوان
      body: Padding(
        // إضافة تباعد للأطراف
        padding: const EdgeInsets.only(
          left: Constant.bookingTileLeftPadding, // تحديد تباعد من اليسار
          right: Constant.bookingTileRightPadding, // تحديد تباعد من اليمين
        ),
        child: SingleChildScrollView(
          // عنصر يمكن التمرير داخله
          physics: const AlwaysScrollableScrollPhysics(), // تحديد خصائص السكروب
          child: Padding(
            // إضافة تباعد للأطراف
            padding: Constant.constantPadding(Constant.SIZE100 / 2), // حساب التباعد بناءً على الحجم المعطى
            child: Padding(
              // إضافة تباعد للأطراف
              padding: const EdgeInsets.only(bottom: 300), // تحديد تباعد من الأسفل
              child: Column(
                // عنصر يتسع للعمود
                children: [
                  // شريط العنوان
                  CustomAppBar(
                    title: "رغباتك فى التبرع", // تحديد عنوان الشريط
                    space: Constant.SIZE15, // تحديد المسافة بين العناصر
                    leftPadding: 15, // تحديد تباعد من اليسار
                    bottomPadding: 10, // تحديد تباعد من الأسفل
                    onTap: () {
                      // إضافة تفاعل عند النقر
                      // تحديث حالة التطبيق
                      connectController.index = Constant.INT_ONE;
                      connectController.update();
                    },
                  ),
                  SizedBox(
                    // حاوية لعنصر يتسع للارتفاع المحدد
                    height: height! * Constant.searchBodyHeight, // تحديد الارتفاع
                    child: StreamBuilder<QuerySnapshot>(
                      // بناء بنية يستجيبة للبيانات المتدفقة
                      stream: FirebaseFirestore.instance
                          .collection('freeDonationRequest')
                          .where('userUid', isEqualTo: userId)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          // التعامل مع حالة وجود خطأ
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // التعامل مع حالة الانتظار
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          // عرض القائمة عند وجود البيانات
                          return ListView.builder(
                            padding: EdgeInsets.only(
                              left: Constant.searchTileListLeftPadding, // تحديد تباعد من اليسار
                              bottom: height! * Constant.searchTileListBottomPadding, // تحديد تباعد من الأسفل
                              right: Constant.searchTileListRightPadding, // تحديد تباعد من اليمين
                              top: Constant.searchTileListTopPadding, // تحديد تباعد من الأعلى
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = snapshot.data!.docs[index]; // الوثيقة الحالية
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>; // البيانات كمصفوفة
                              // استخراج البيانات من الوثيقة
                              String userName = data['userName'];
                              String userEmail = data['userEmail'];
                              String hospitalUID = data['hospitalUID'];
                              String userBloodType = data['userBloodType'];
                              String userChronicDiseases = data['userChronicDiseases'];
                              String userHeight = data['userHeight'];
                              String userWeight = data['userWeight'];
                              String status = data['status'];
                              String documentDetailuid = document.id; // معرف الوثيقة

                              // تحويل التاريخ لنص
                              DateTime now2 = data['time']?.toDate() ?? DateTime.now();
                              DateFormat formatter2 = DateFormat.yMd().add_jm();
                              String time = formatter2.format(now2);

                              return Stack(
                                // تراص العناصر
                                children: [
                                  // تأثير زجاجي خلفي
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: Constant.blurSigmaX,
                                        sigmaY: Constant.blurSigmaY), // تحديد مستوى التأثير
                                  ),
                                  InkWell(
                                    // عنصر تفاعلي
                                    onTap: () {
                                      FocusScope.of(context).unfocus(); // إخفاء لوحة المفاتيح عند النقر
                                    },
                                    child: Container(
                                      // حاوية للعناصر
                                      margin: const EdgeInsets.all(Constant.searchTileMargin), // تحديد تباعد الحاوية
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              Constant.searchTileContentBottomPadding), // تحديد تباعد الحاوية الداخلي
                                      decoration: Constant.boxDecoration, // تحديد تزيين الحاوية
                                      child: Row(
                                        // عنصر يمتد على الأفق
                                        crossAxisAlignment: CrossAxisAlignment.start, // تحديد توجيه العناصر
                                        children: [
                                          Padding(
                                            // إضافة تباعد للأطراف
                                            padding: const EdgeInsets.only(right: 8.0), // تحديد تباعد من اليمين
                                            child: Column(
                                              // عنصر يمتد على الرأس
                                              mainAxisAlignment: MainAxisAlignment.start, // تحديد توجيه العناصر
                                              crossAxisAlignment: CrossAxisAlignment.start, // تحديد توجيه العناصر
                                              children: [
                                                const SizedBox(
                                                  // إضافة تباعد بين العناصر
                                                  height: 20, // تحديد الارتفاع
                                                ),
                                                // عنوان الطلب
                                                CustomText(
                                                  title: 'إسم المتبرع $userName', // تحديد العنوان
                                                  fontSize: Constant.searchTileTitleSize, // تحديد حجم الخط
                                                  color: AppTheme.colorblack, // تحديد لون النص
                                                  fontWight: FontWeight.w900, // تحديد وزن الخط
                                                ),
                                                // وصف الطلب
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: Constant.tripCardLocationPadding), // تحديد تباعد من الأعلى
                                                  child: SizedBox(
                                                    // حاوية للعنصر
                                                    width: width! * 0.7, // تحديد العرض
                                                    child: CustomText(
                                                      // عنصر نصي مخصص
                                                      title: "بريد المتبرع : $userEmail", // تحديد النص
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      textAlign: TextAlign.right, // تحديد محاذاة النص
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                      fontWight: FontWeight.w400, // تحديد وزن الخط
                                                    ),
                                                  ),
                                                ),
                                                // رقم الطلب
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: Constant.tripCardLocationPadding), // تحديد تباعد من الأعلى
                                                  child: SizedBox(
                                                    // حاوية للعنصر
                                                    width: width! * 0.7, // تحديد العرض
                                                    child: CustomText(
                                                      // عنصر نصي مخصص
                                                      title: "فصيلة الدم : $userBloodType", // تحديد النص
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                      fontWight: FontWeight.w400, // تحديد وزن الخط
                                                    ),
                                                  ),
                                                ),
                                                // نوع الفصيلة المطلوبة
                                                SizedBox(
                                                  // حاوية للعنصر
                                                  width: width! * 0.75, // تحديد العرض
                                                  child: Text(
                                                    // عنصر نصي عادي
                                                    "الأمراض المزمنة : $userChronicDiseases", // تحديد النص
                                                    style: TextStyle(
                                                      // تحديد السمات
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                    ),
                                                  ),
                                                ),
                                                // ميعاد تقديم التبرع
                                                SizedBox(
                                                  // حاوية للعنصر
                                                  width: width! * 0.75, // تحديد العرض
                                                  child: Text(
                                                    // عنصر نصي عادي
                                                    "ميعاد تقديم الطلب : $time", // تحديد النص
                                                    style: TextStyle(
                                                      // تحديد السمات
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                    ),
                                                  ),
                                                ),

                                                Text(
                                                  // عنصر نصي عادي
                                                  "الطول : $userHeight | الوزن : $userWeight", // تحديد النص
                                                  style: TextStyle(
                                                    // تحديد السمات
                                                    fontSize: width! * 0.04, // تحديد حجم الخط
                                                    color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                  ),
                                                ),
                                                status == 'panding'
                                                    ? Text(
                                                        // عنصر نصي عادي
                                                        "جاري مراجعه الطلب", // تحديد النص
                                                        style: TextStyle(
                                                          // تحديد السمات
                                                          fontSize: width! * 0.04, // تحديد حجم الخط
                                                          color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                status == 'Accepted'
                                                    ? Text(
                                                        // عنصر نصي عادي
                                                        "تم قبول طلبك", // تحديد النص
                                                        style: TextStyle(
                                                          // تحديد السمات
                                                          fontSize: width! * 0.04, // تحديد حجم الخط
                                                          color: Colors.green, // تحديد لون النص
                                                        ),
                                                      )
                                                    : const SizedBox(),

                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                  ),
                                                  child: SizedBox(
                                                    width: width! * 0.7,
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
                                                                .collection('freeDonationRequest')
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
                    // إضافة تباعد بين العناصر
                    height: 200, // تحديد الارتفاع
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  userDonationsRequests() {
    // تحديد الارتفاع والعرض باستخدام MediaQuery
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // بناء واجهة Scaffold
    return Scaffold(
      backgroundColor: AppTheme.colorTransprant, // تحديد لون الخلفية
      appBar: NoAppBar(), // إزالة شريط العنوان
      body: Padding(
        // إضافة تباعد للأطراف
        padding: const EdgeInsets.only(
          left: Constant.bookingTileLeftPadding, // تحديد تباعد من اليسار
          right: Constant.bookingTileRightPadding, // تحديد تباعد من اليمين
        ),
        child: SingleChildScrollView(
          // عنصر يمكن التمرير داخله
          physics: const AlwaysScrollableScrollPhysics(), // تحديد خصائص السكروب
          child: Padding(
            // إضافة تباعد للأطراف
            padding: Constant.constantPadding(Constant.SIZE100 / 2), // حساب التباعد بناءً على الحجم المعطى
            child: Padding(
              // إضافة تباعد للأطراف
              padding: const EdgeInsets.only(bottom: 300), // تحديد تباعد من الأسفل
              child: Column(
                // عنصر يتسع للعمود
                children: [
                  // شريط العنوان
                  CustomAppBar(
                    title: "كل الطلبات الخاصه بك", // تحديد عنوان الشريط
                    space: Constant.SIZE15, // تحديد المسافة بين العناصر
                    leftPadding: 15, // تحديد تباعد من اليسار
                    bottomPadding: 10, // تحديد تباعد من الأسفل
                    onTap: () {
                      // إضافة تفاعل عند النقر
                      // تحديث حالة التطبيق
                      connectController.index = Constant.INT_ONE;
                      connectController.update();
                    },
                  ),
                  SizedBox(
                    // حاوية لعنصر يتسع للارتفاع المحدد
                    height: height! * Constant.searchBodyHeight, // تحديد الارتفاع
                    child: StreamBuilder<QuerySnapshot>(
                      // بناء بنية يستجيبة للبيانات المتدفقة
                      stream: FirebaseFirestore.instance
                          .collection('userDonationRequestWithHospital')
                          .where('userUid', isEqualTo: userId)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          // التعامل مع حالة وجود خطأ
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // التعامل مع حالة الانتظار
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          // عرض القائمة عند وجود البيانات
                          return ListView.builder(
                            padding: EdgeInsets.only(
                              left: Constant.searchTileListLeftPadding, // تحديد تباعد من اليسار
                              bottom: height! * Constant.searchTileListBottomPadding, // تحديد تباعد من الأسفل
                              right: Constant.searchTileListRightPadding, // تحديد تباعد من اليمين
                              top: Constant.searchTileListTopPadding, // تحديد تباعد من الأعلى
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = snapshot.data!.docs[index]; // الوثيقة الحالية
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>; // البيانات كمصفوفة
                              // استخراج البيانات من الوثيقة
                              String title = data['title'];
                              String bloodGroups = data['bloodGroups'];
                              String description = data['description'];
                              String ticketId = data['ticketId'];
                              String userName = data['userName'];
                              String userEmail = data['userEmail'];
                              String hospitalUID = data['hospitalUID'];
                              String status = data['status'];
                              String donationDeadline = data['donationDeadline'];
                              String documentDetailuid = document.id; // معرف الوثيقة

                              // تحويل التاريخ لنص
                              DateTime now2 = data['time']?.toDate() ?? DateTime.now();
                              DateFormat formatter2 = DateFormat.yMd().add_jm();
                              String time = formatter2.format(now2);

                              return Stack(
                                // تراص العناصر
                                children: [
                                  // تأثير زجاجي خلفي
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: Constant.blurSigmaX,
                                        sigmaY: Constant.blurSigmaY), // تحديد مستوى التأثير
                                  ),
                                  InkWell(
                                    // عنصر تفاعلي
                                    onTap: () {
                                      FocusScope.of(context).unfocus(); // إخفاء لوحة المفاتيح عند النقر
                                    },
                                    child: Container(
                                      // حاوية للعناصر
                                      margin: const EdgeInsets.all(Constant.searchTileMargin), // تحديد تباعد الحاوية
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              Constant.searchTileContentBottomPadding), // تحديد تباعد الحاوية الداخلي
                                      decoration: Constant.boxDecoration, // تحديد تزيين الحاوية
                                      child: Row(
                                        // عنصر يمتد على الأفق
                                        crossAxisAlignment: CrossAxisAlignment.start, // تحديد توجيه العناصر
                                        children: [
                                          Padding(
                                            // إضافة تباعد للأطراف
                                            padding: const EdgeInsets.only(right: 8.0), // تحديد تباعد من اليمين
                                            child: Column(
                                              // عنصر يمتد على الرأس
                                              mainAxisAlignment: MainAxisAlignment.start, // تحديد توجيه العناصر
                                              crossAxisAlignment: CrossAxisAlignment.start, // تحديد توجيه العناصر
                                              children: [
                                                const SizedBox(
                                                  // إضافة تباعد بين العناصر
                                                  height: 20, // تحديد الارتفاع
                                                ),
                                                // عنوان الطلب
                                                CustomText(
                                                  title: title, // تحديد العنوان
                                                  fontSize: Constant.searchTileTitleSize, // تحديد حجم الخط
                                                  color: AppTheme.colorblack, // تحديد لون النص
                                                  fontWight: FontWeight.w900, // تحديد وزن الخط
                                                ),
                                                // وصف الطلب
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: Constant.tripCardLocationPadding), // تحديد تباعد من الأعلى
                                                  child: SizedBox(
                                                    // حاوية للعنصر
                                                    width: width! * 0.7, // تحديد العرض
                                                    child: CustomText(
                                                      // عنصر نصي مخصص
                                                      title: "وصف الطلب : $description", // تحديد النص
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      textAlign: TextAlign.right, // تحديد محاذاة النص
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                      fontWight: FontWeight.w400, // تحديد وزن الخط
                                                    ),
                                                  ),
                                                ),
                                                // رقم الطلب
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: Constant.tripCardLocationPadding), // تحديد تباعد من الأعلى
                                                  child: SizedBox(
                                                    // حاوية للعنصر
                                                    width: width! * 0.7, // تحديد العرض
                                                    child: CustomText(
                                                      // عنصر نصي مخصص
                                                      title: "رقم الطلب : $ticketId", // تحديد النص
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                      fontWight: FontWeight.w400, // تحديد وزن الخط
                                                    ),
                                                  ),
                                                ),
                                                // نوع الفصيلة المطلوبة
                                                SizedBox(
                                                  // حاوية للعنصر
                                                  width: width! * 0.75, // تحديد العرض
                                                  child: Text(
                                                    // عنصر نصي عادي
                                                    "نوع الفصيلة المطلوبة : $bloodGroups", // تحديد النص
                                                    style: TextStyle(
                                                      // تحديد السمات
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                    ),
                                                  ),
                                                ),
                                                // ميعاد تقديم التبرع
                                                SizedBox(
                                                  // حاوية للعنصر
                                                  width: width! * 0.75, // تحديد العرض
                                                  child: Text(
                                                    // عنصر نصي عادي
                                                    "ميعاد تقديمك على التبرع : $time", // تحديد النص
                                                    style: TextStyle(
                                                      // تحديد السمات
                                                      fontSize: width! * 0.04, // تحديد حجم الخط
                                                      color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                    ),
                                                  ),
                                                ),
                                                // ميعاد التبرع
                                                Text(
                                                  // عنصر نصي عادي
                                                  "ميعاد التبرع : $donationDeadline", // تحديد النص
                                                  style: TextStyle(
                                                    // تحديد السمات
                                                    fontSize: width! * 0.04, // تحديد حجم الخط
                                                    color: AppTheme.tripCardLocationColor, // تحديد لون النص
                                                  ),
                                                ),
                                                status == 'panding'
                                                    ? Text(
                                                        // عنصر نصي عادي
                                                        "جاري مراجعه الطلب", // تحديد النص
                                                        style: TextStyle(
                                                          // تحديد السمات
                                                          fontSize: width! * 0.04, // تحديد حجم الخط
                                                          color: Colors.blue, // تحديد لون النص
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                status == 'Accepted'
                                                    ? Text(
                                                        // عنصر نصي عادي
                                                        "تم قبول طلبك", // تحديد النص
                                                        style: TextStyle(
                                                          // تحديد السمات
                                                          fontSize: width! * 0.04, // تحديد حجم الخط
                                                          color: Colors.green, // تحديد لون النص
                                                        ),
                                                      )
                                                    : const SizedBox(),

                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                  ),
                                                  child: SizedBox(
                                                    width: width! * 0.7,
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
                                                // زر "المزيد"
                                                // InkWell(
                                                //   onTap: () async {
                                                //     // عرض تفاصيل المزيد
                                                //     homeController.index = Constant.INT_SIX;
                                                //     homeController.update();
                                                //     setState(() {
                                                //       documentDetailId = documentDetailuid;
                                                //     });
                                                //   },
                                                //   child: CustomText(
                                                //     topPadding: Constant.moreTextTopPadding,
                                                //     title: Strings.more,
                                                //     fontSize: Constant.moreTextSize,
                                                //     fontfamily: Strings.emptyString,
                                                //     color: AppTheme.themeColor,
                                                //     fontWight: FontWeight.w400,
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
                    // إضافة تباعد بين العناصر
                    height: 200, // تحديد الارتفاع
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _allHospitalDonationRequests() {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
                    title: "طلبات التبرع الخاصة بك",
                    space: Constant.SIZE15,
                    leftPadding: 15,
                    bottomPadding: 10,
                    onTap: () {
                      // تحديث حالة التطبيق عند النقر على شريط العنوان
                      connectController.index = Constant.INT_ONE;
                      connectController.update();
                    },
                  ),
                  SizedBox(
                    height: height! * Constant.searchBodyHeight,
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
                          // عرض قائمة الأماكن السياحية
                          return ListView.builder(
                            padding: EdgeInsets.only(
                              left: Constant.searchTileListLeftPadding,
                              bottom: height! * Constant.searchTileListBottomPadding,
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
                              // String status = data['status'];
                              int numberDonorsRequired = data['numberDonorsRequired'];
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
                                                    width: width! * 0.7,
                                                    child: CustomText(
                                                      title: "وصف الطلب : $description",
                                                      fontSize: width! * 0.04,
                                                      color: AppTheme.tripCardLocationColor,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: width! * 0.75,
                                                  child: Text(
                                                    "نوع الفصيلةالمطلوبة : $bloodGroups",
                                                    style: TextStyle(
                                                      fontSize: width! * 0.04,
                                                      color: AppTheme.tripCardLocationColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width! * 0.75,
                                                  child: Text(
                                                    "ميعاد التبرع : $date",
                                                    style: TextStyle(
                                                      fontSize: width! * 0.04,
                                                      color: AppTheme.tripCardLocationColor,
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                  ),
                                                  child: SizedBox(
                                                    width: width! * 0.7,
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
    );
  }

  // دالة لعرض الجزء المتعلق بعرض التجارب
  _superLeadsBody() {
    return Scaffold(
      backgroundColor: AppTheme.connectBodyColor,
      appBar: NoAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Constant.bookingTileLeftPadding,
          right: Constant.bookingTileRightPadding,
        ),
        child: Padding(
          padding: Constant.constantPadding(Constant.SIZE100 / 2),
          child: Column(
            children: [
              // شريط عنوان لعرض عنوان الصفحة
              CustomAppBar(
                  title: Strings.donationRequest,
                  space: Constant.SIZE15,
                  leftPadding: 15,
                  bottomPadding: 10,
                  onTap: () {
                    connectController.index = Constant.INT_ONE;
                    connectController.update();
                  }),
              const SizedBox(
                height: Constant.SIZE15,
              ),
              Expanded(
                // عرض التجارب باستخدام StreamBuilder
                child: StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(width: 40, height: 40, child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        // استخدام ListView.builder لعرض التجارب بشكل ديناميكي
                        return ListView.builder(
                          padding: const EdgeInsets.only(
                            left: Constant.searchTileListLeftPadding,
                            right: Constant.searchTileListRightPadding,
                            top: Constant.searchTileListTopPadding,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = snapshot.data!.docs[index];
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                            String title = data['title'];
                            String landmark = data['bloodGroups'];
                            String address = data['date'];
                            String description = data['description'];

                            // عرض بيانات التجربة باستخدام ConnectTile
                            return ConnectTile(
                              isGroupTile: false,
                              title: title,
                              address: address,
                              description: description,
                              landmark: landmark,
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  // دالة لعرض مربع خيارات
  optionBox({required String icon, required String title, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.connectOptionBoxTopPadding),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height! * Constant.connectOptionBoxHeight,
          width: width! * Constant.connectOptionBoxWidth * 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.connectOptionBoxRadius),
            color: AppTheme.colorWhite,
            boxShadow: [
              Constant.boxShadow(
                color: AppTheme.greyColor,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: Constant.connectOptionBoxIconRightPadding),
                child: SvgPicture.asset(
                  icon,
                  color: AppTheme.themeColor,
                  height: Constant.connectOptionBoxIconSize,
                  width: Constant.connectOptionBoxIconSize,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                title: title,
                fontfamily: Strings.emptyString,
                color: AppTheme.themeColor,
                fontWight: FontWeight.w400,
                fontSize: Constant.connectOptionBoxTitleSize,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colorRed,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '11:00 ~ 12:10',
                style: TextStyle(
                  color: AppTheme.colorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                Icons.access_alarm,
                color: AppTheme.colorRed,
                size: 17,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'الاحد, مارس 29',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.colorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                Icons.calendar_today,
                color: AppTheme.colorRed,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
