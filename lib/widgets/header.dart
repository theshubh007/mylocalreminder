import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            "Create a Reminder",
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Icon(Icons.notifications_active),
        ],
      ),
    );
  }
}
