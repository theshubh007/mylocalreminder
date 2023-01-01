import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateField extends StatelessWidget {
  const DateField({Key? key, required this.eventDate}) : super(key: key);
  final DateTime? eventDate;

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
              eventDate == null
                  ? "Select the event day"
                  : DateFormat("EEEE, d MMM y").format(eventDate!),
              maxLines: 1,
              style: TextStyle(
                fontSize: 16.sp,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.calendar_today_outlined,
            size: 18.sp,
          ),
        ],
      ),
    );
  }
}
