import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mylocalreminder/Reminderpage.dart';
import 'package:mylocalreminder/helper/dbservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (ctx, child) {
          return const GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: Reminderpage(),
          );
        });
  }
}
