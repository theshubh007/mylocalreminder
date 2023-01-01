import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mylocalreminder/Notification_service.dart';
import 'package:mylocalreminder/display.dart';
import 'package:mylocalreminder/helper/dbservice.dart';
import 'package:mylocalreminder/helper/task.dart';
import 'package:mylocalreminder/widgets/action_buttons.dart';
import 'package:mylocalreminder/widgets/custom_day_picker.dart';
import 'package:mylocalreminder/widgets/date_field.dart';
import 'package:mylocalreminder/widgets/header.dart';
import 'package:mylocalreminder/widgets/time_field.dart';

class Reminderpage extends StatefulWidget {
  const Reminderpage({Key? key}) : super(key: key);

  @override
  State<Reminderpage> createState() => _ReminderpageState();
}

class _ReminderpageState extends State<Reminderpage> {
  NotificationService notificationService = NotificationService();

  RxInt maxTitleLength = 60.obs;
  final TextEditingController _textEditingController =
      TextEditingController(text: "task name");

  int segmentedControlGroupValue = 0;
  int notificationid = 0;

  DateTime currentDate = DateTime.now();
  DateTime? eventDate;

  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay? eventTime;

  Future<void> _addTaskToDB() async {
    final Task task = Task();
    task.title = _textEditingController.text;
    task.body = "A new event body has been created.";
    task.repeat = "Yes";
    task.date = eventDate!.toString();
    task.time = eventTime!.toString();

    await DBHelper().insertTask(task);
  }

  Future<void> onCreate() async {
    await notificationService.showNotification(
      1,
      _textEditingController.text,
      "A new event has been created.",
      jsonEncode({
        "title": _textEditingController.text,
        "eventDate": DateFormat("EEEE, d MMM y").format(eventDate!),
        "eventTime": eventTime!.format(context),
      }),
    );

    await notificationService.scheduleNotification(
      1,
      _textEditingController.text,
      "Reminder for your scheduled event at ${eventTime!.format(context)}",
      eventDate!,
      eventTime!,
      jsonEncode({
        "title": _textEditingController.text,
        "eventDate": DateFormat("EEEE, d MMM y").format(eventDate!),
        "eventTime": eventTime!.format(context),
      }),
      getDateTimeComponents(),
    );

    _addTaskToDB();
    resetForm();
    // }
  }

  Future<void> cancelAllNotifications() async {
    await notificationService.cancelAllNotifications();
  }

  void resetForm() {
    segmentedControlGroupValue = 0;
    eventDate = null;
    eventTime = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScreenUtil.init(context, designSize: const Size(360, 690));
    });
    NotificationService().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setup Reminder"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const Displayreminder());
            },
            icon: const Icon(Icons.library_books_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          // padding: getPadding(left: 15, right: 15, top: 8),
          padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 8.h),
          child: Card(
            child: Padding(
              // padding: getPadding(left: 24, right: 24, top: 24, bottom: 24),
              padding: EdgeInsets.only(
                  left: 24.w, right: 24.w, top: 24.h, bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Header(),
                  TextField(
                    controller: _textEditingController,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      counterText: "",
                    ),
                  ),
                  SizedBox(height: 36.h),
                  CupertinoSlidingSegmentedControl<int>(
                    onValueChanged: (value) {
                      if (value == 1) eventDate = null;
                      setState(() => segmentedControlGroupValue = value!);
                    },
                    groupValue: segmentedControlGroupValue,
                    padding: EdgeInsets.only(
                        left: 4.w, right: 4.w, top: 4.h, bottom: 4.h),
                    children: const <int, Widget>{
                      0: Text(
                        "One time",
                        maxLines: 1,
                        style: TextStyle(
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      1: Text(
                        "Daily",
                        style: TextStyle(
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      2: Text(
                        "Weekly",
                        style: TextStyle(
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    },
                  ),
                  SizedBox(height: 24.h),
                  AutoSizeText(
                    "Date & Time",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  GestureDetector(
                    onTap: selectEventDate,
                    child: DateField(eventDate: eventDate),
                  ),
                  SizedBox(height: 14.h),
                  GestureDetector(
                    onTap: () async {
                      eventTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: currentTime.hour,
                          minute: currentTime.minute + 1,
                        ),
                      );
                      setState(() {});
                    },
                    child: TimeField(eventTime: eventTime),
                  ),
                  SizedBox(height: 18.h),
                  ActionButtons(
                    onCreate: onCreate,
                    onCancel: resetForm,
                  ),
                  const SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () async {
                      await cancelAllNotifications();
                    },
                    child: _buildCancelAllButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelAllButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.indigo[100],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            "Cancel all the reminders",
            maxLines: 1,
            style: TextStyle(
              fontSize: 16.sp,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Icon(Icons.clear),
        ],
      ),
    );
  }

  DateTimeComponents? getDateTimeComponents() {
    if (segmentedControlGroupValue == 1) {
      return DateTimeComponents.time;
    } else if (segmentedControlGroupValue == 2) {
      return DateTimeComponents.dayOfWeekAndTime;
    }
    return null;
  }

  void selectEventDate() async {
    final today =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    if (segmentedControlGroupValue == 0) {
      eventDate = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: today,
        lastDate: DateTime(currentDate.year + 10),
      );
      setState(() {});
    } else if (segmentedControlGroupValue == 1) {
      setState(() {
        eventDate = today;
      });
    } else if (segmentedControlGroupValue == 2) {
      CustomDayPicker(
        onDaySelect: (val) {
          print("$val: ${CustomDayPicker.weekdays[val]}");
          eventDate = today.add(
              Duration(days: (val - today.weekday + 1) % DateTime.daysPerWeek));
        },
      ).show(context);
    }
  }

  Widget buildSegment(String text) {
    return Container(
      child: AutoSizeText(
        text,
        maxLines: 1,
        overflow: TextOverflow.fade,
        style: TextStyle(fontSize: 16.sp, color: Colors.black),
      ),
    );
  }
}
