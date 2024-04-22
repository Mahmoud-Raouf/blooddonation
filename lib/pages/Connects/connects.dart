import 'package:blooddonation/pages/Connects/connects_controller.dart';
import 'package:blooddonation/webservices/firebase_data.dart';
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

class DonationRequest extends StatefulWidget {
  const DonationRequest({super.key});

  @override
  State<DonationRequest> createState() => _DonationRequestState();
}

class _DonationRequestState extends State<DonationRequest> {
  double? height;
  double? width;

  static String? hospitalsId;
  static String? UserUid;

  static Future<void> initialize() async {
    getclinicAppointmentsDocument();
  }

  @override
  void initState() {
    super.initState();

    // استدعاء دوال الحصول على البيانات عند بداية تحميل الصفحة
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
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  addDonationRequest() async {
    // الحصول على معرف المستخدم المسجل دخوله
    CollectionReference donationRequestRef = FirebaseFirestore.instance.collection('hospitals');
    // إضافة الطلب إلى مجموعة donationRequest داخل hospitals
    await donationRequestRef.doc(hospitalsId).collection('donationRequest').add({
      "title": title.text,
      'date': _selectedDate,
      'bloodGroups': bloodType.text,
      'description': description.text,
    });

    // بعد إضافة التجربة، نقوم بالانتقال إلى الشاشة الرئيسية
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

              case Constant.INT_FOUR:
                return _superLeadsBody();

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // عناصر لتحديد الخيارات المتاحة للمستخدم
          optionBox(
              icon: superLeads,
              title: Strings.addOrder,
              onTap: () {
                connectController.index = Constant.INT_FOUR;
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
    return Scaffold(
      backgroundColor: AppTheme.connectBodyColor,
      appBar: NoAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: Constant.bookingTileLeftPadding,
            right: Constant.bookingTileRightPadding,
          ),
          child: Column(
            children: [
              Padding(
                padding: Constant.constantPadding(Constant.SIZE100 / 2),
                child: CustomAppBar(
                    leftPadding: 15,
                    bottomPadding: 10,
                    title: Strings.addOrder,
                    space: Constant.SIZE15,
                    onTap: () {
                      connectController.index = Constant.INT_ONE;
                      connectController.update();
                    }),
              ),
              Container(
                color: AppTheme.loginPageColor,
                height: height,
                width: width,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 22,
                        ),
                        // واجهات إدخال لإدخال بيانات التجربة
                        CustomTextFeild(
                          controller: title,
                          hintText: "العنوان :",
                          hintSize: 16,
                          contentRightPadding: 10,
                          onTap: () {},
                          onChanged: (newValue) => newValue,
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
                        const SizedBox(
                          height: 22,
                        ),
                        SizedBox(
                          width: 240,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.colorRed,
                              ),
                              child: const Text('تحديد موعد التبرع'),
                              onPressed: () async {
                                // Show the date picker
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                // Update the selected date
                                setState(() {
                                  _selectedDate = selectedDate ?? _selectedDate;
                                });
                              }),
                        ),
                        // زر لإضافة التجربة
                        CustomButton(
                          backgroundColor: AppTheme.customButtonBgColor,
                          borderColor: AppTheme.customButtonBgColor,
                          buttonTitle: Strings.add,
                          height: Constant.customButtonHeight,
                          onTap: () async {
                            // Update the selected date
                            addDonationRequest();
                          },
                          textColor: AppTheme.colorWhite,
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
