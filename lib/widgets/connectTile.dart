import 'package:flutter/material.dart';
import 'package:blooddonation/theme/app_theme.dart';
import 'package:blooddonation/util/_string.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/widgets/custom_text.dart';

// تعريف عنصر ConnectTile لعرض بيانات الاتصال أو المجموعة
class ConnectTile extends StatefulWidget {
  String title; // عنوان العنصر
  String address; // عنوان العنصر
  String description; // وصف العنصر
  String landmark; // المعلم المميز
  void Function()? onTap; // دالة التفاعل عند النقر على العنصر
  bool isGroupTile; // متغير يحدد إذا كان العنصر يمثل مجموعة أم لا
  bool wantToAddMore; // متغير يحدد إذا كان يريد إضافة المزيد من المعلومات

  ConnectTile(
      {super.key,
      this.wantToAddMore = false,
      this.isGroupTile = true,
      required this.title,
      required this.address,
      required this.description,
      required this.landmark,
      this.onTap});

  @override
  State<ConnectTile> createState() => _ConnectTileState();
}

class _ConnectTileState extends State<ConnectTile> {
  double? width;

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة
    width = MediaQuery.of(context).size.width;
    final ksize = MediaQuery.of(context).size;
    // بناء العنصر باستخدام InkWell و Container و CustomText
    return InkWell(
      highlightColor: AppTheme.colorTransprant,
      splashColor: AppTheme.colorTransprant,
      onTap: widget.onTap, // تعيين دالة التفاعل عند النقر
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.only(
            bottom: Constant.groupTileBottomMargin,
          ),
          padding: EdgeInsets.only(
            left: Constant.groupTileLeftPadding,
            right: Constant.groupTileRightPadding,
            top: widget.wantToAddMore ? Constant.superLeadsTileTopPadding : Constant.groupTileTopPadding,
            bottom: Constant.groupTileBottomPadding,
          ),
          width: width,
          decoration: BoxDecoration(
            color: AppTheme.colorWhite,
            borderRadius: BorderRadius.circular(
              Constant.groupTileRadius,
            ),
            boxShadow: [
              Constant.boxShadow(
                color: AppTheme.greyColor,
                opacity: Constant.groupTileBoxShadowOpacity,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CustomText لعرض عنوان العنصر
                      CustomText(
                        title: widget.title,
                        fontSize: Constant.groupTileTitleSize * 1.1,
                        fontfamily: Strings.emptyString,
                        fontWight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10.0),
                      // CustomText لعرض عنوان العنصر
                      CustomText(
                        topPadding: Constant.groupTileSubTitleTopPadding,
                        title: "العنوان : ${widget.address}",
                        fontSize: ksize.width * 0.04,
                        fontfamily: Strings.emptyString,
                        fontWight: FontWeight.w300,
                        color: AppTheme.connectSubTitleThemeColor,
                      ),
                      const SizedBox(height: 5.0),
                      // CustomText لعرض المعلم المميز
                      CustomText(
                        topPadding: Constant.groupTileSubTitleTopPadding,
                        title: "المعلم : ${widget.landmark}",
                        fontSize: ksize.width * 0.05,
                        fontfamily: Strings.emptyString,
                        fontWight: FontWeight.w300,
                        color: AppTheme.connectSubTitleThemeColor,
                      ),
                      const SizedBox(height: 1.0),
                      // Divider لخط الفاصل
                      const Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      // Container لعرض الوصف مع CustomText
                      SizedBox(
                        width: ksize.width * 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 231, 231, 231),
                            borderRadius: BorderRadius.circular(
                              Constant.groupTileRadius,
                            ),
                            boxShadow: [
                              Constant.boxShadow(
                                color: AppTheme.greyColor,
                                opacity: Constant.groupTileBoxShadowOpacity,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomText(
                              topPadding: 3,
                              wordSpacing: 0.2,
                              title: widget.description,
                              fontSize: ksize.width * 0.05,
                              fontfamily: Strings.emptyString,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
