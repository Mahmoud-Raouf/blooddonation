import 'package:flutter/material.dart';
import 'package:blooddonation/util/constants.dart';
import 'package:blooddonation/util/places.dart';
import 'package:blooddonation/widgets/_appbar.dart';
import 'package:blooddonation/widgets/no_appbar.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NoAppBar(), // شريط التطبيق بدون قائمة (AppBar)
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 30.0),
          CustomAppBar(
              title: "All landmarks", space: Constant.SIZE15, leftPadding: 15, bottomPadding: 10, onTap: () {}),
          const SizedBox(height: 10.0),
          buildSlider(), // عنصر لعرض الصور بشكل أفقي
          const SizedBox(height: 20),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              // عنوان المكان مع زر الحفظ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${places[0]["name"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              // الموقع
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.blueGrey[300],
                  ),
                  const SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${places[0]["location"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.blueGrey[300],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // السعر
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${places[0]["price"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 40),
              // تفاصيل
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10.0),
              // تفاصيل المكان
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${places[0]["details"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ],
      ),
    );
  }

  // عنصر لعرض الصور بشكل أفقي
  buildSlider() {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: places == null ? 0 : places.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = places[index];

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                "${place["img"]}",
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
}
