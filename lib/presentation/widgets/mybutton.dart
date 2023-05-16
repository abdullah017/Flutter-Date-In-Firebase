// ignore_for_file: deprecated_member_use

import 'package:date_in_firebase/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      required this.color,
      required this.width,
      required this.title,
      required this.func})
      : super(key: key);

  final Color color;
  final double width;
  final String title;
  final Function() func;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 0.1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: color,
      ),
      child: MaterialButton(
        onPressed: func,
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(fontSize: 11.sp, color: Appcolors.white),
        ),
      ),
    );
  }
}
