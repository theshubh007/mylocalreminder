import 'package:flutter/material.dart';
import 'package:mylocalreminder/helper/dbservice.dart';

class Displayreminder extends StatefulWidget {
  const Displayreminder({super.key});

  @override
  State<Displayreminder> createState() => _DisplayreminderState();
}

class _DisplayreminderState extends State<Displayreminder> {
  var temp = [];
  bool isloaded = false;
  Future<void> fetchdbdata() async {
    var curr = await DBHelper().getalltaskdetails();
    setState(() {
      temp = curr;
      isloaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdbdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: isloaded
          ? ListView.builder(
              itemCount: temp.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(temp[index].title),
                    subtitle: Text(temp[index].date),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }
}
