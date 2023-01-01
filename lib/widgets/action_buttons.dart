import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
    required this.onCreate,
    required this.onCancel,
  }) : super(key: key);
  final VoidCallback onCreate;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.grey[200],
          ),
          child: const AutoSizeText(
            "Cancel",
            style: TextStyle(color: Colors.black87),
          ),
        ),
        SizedBox(width: 10.sp),
        ElevatedButton(
          onPressed: onCreate,
          child: const AutoSizeText("Create"),
        ),
      ],
    );
  }
}
