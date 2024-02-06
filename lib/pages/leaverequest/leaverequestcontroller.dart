import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/const/stringconst.dart';

class LeaveRequestController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final commentController = TextEditingController();
  var selectedLeaveType = "".obs;
  RxList mainiteams = [].obs;
  RxList extraiteam = ['n'].obs;
  List selectedItems = [];
  var extra = ''.obs;
  var name = "".obs;
  var lastname = "".obs;
  var userid = "".obs;
  var noselected = 'chapathi'.obs;
  var selected = "".obs;




  oninit() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('userid');

    var user = prefs.getString(Appstring.loginid);
    userid.value = user as String;
    name.value = username as String;
    lastname.value = prefs.getString(Appstring.lastname)!;

  }


  void submitForm() {
    if (formKey.currentState!.validate()) {
      print("Leave type: ${selectedLeaveType.value}");
      print("Start date: ${startDateController.text}");
      print("End date: ${endDateController.text}");
      print("Comment: ${commentController.text}");
    }
  }

}

