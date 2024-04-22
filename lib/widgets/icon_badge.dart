import 'package:flutter/material.dart';

class IconBadge extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;

  const IconBadge({super.key, required this.icon, required this.size, required this.color});

  @override
  _IconBadgeState createState() => _IconBadgeState();
}

class _IconBadgeState extends State<IconBadge> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // العنصر الأول: أيقونة
        Icon(
          widget.icon, // نوع الأيقونة المُعطاة
          size: widget.size, // حجم الأيقونة المُعطى
          color: widget.color, // لون الأيقونة المُعطى
        ),
        // العنصر الثاني: علامة (Indicator)
        Positioned(
          right: 0.0,
          top: 0.0,
          child: Container(
            // حاوية تحتوي على علامة التبديل
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // لون الحاوية الرئيسية
              borderRadius: BorderRadius.circular(6), // زوايا مستديرة للحاوية
            ),
            height: 12.0,
            width: 12.0,
            child: Container(
              // حاوية داخلية لعلامة التبديل
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red[300], // لون علامة التبديل
                borderRadius: BorderRadius.circular(6), // زوايا مستديرة لعلامة التبديل
              ),
              height: 7.0,
              width: 7.0,
            ),
          ),
        ),
      ],
    );
  }
}
