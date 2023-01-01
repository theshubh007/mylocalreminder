import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeField extends StatelessWidget {
  const TimeField({Key? key, required this.eventTime}) : super(key: key);
  final TimeOfDay? eventTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: AutoSizeText(
              eventTime == null
                  ? "Select the event time"
                  : eventTime!.format(context),
              style: TextStyle(
                fontSize: 16.sp,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.timer_rounded,
            size: 18.sp,
          )
        ],
      ),
    );
  }
}
