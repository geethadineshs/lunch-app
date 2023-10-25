import 'dart:convert';

import 'package:acsfoodapp/const/resourceconst.dart';
import 'package:acsfoodapp/const/stringconst.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as d;

class Homecontroller extends GetxController {
  var currentMonthCount = 0.obs;
  var prevMonthCount = 0.obs;
  var amount = 0.obs;
  var previousMonthAmount = 0.obs;
  var name = "".obs;
  var month = "".obs;
  var previousMonth = "".obs;
  var isbooked = false.obs;

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userid');
    await prefs.remove("key");
  }

  oninit() async {
    var months = DateFormat.MMMM().format(DateTime.now());
    month.value = months;
    DateTime currentDate = DateTime.now();
    var prev = DateTime(currentDate.year, currentDate.month - 1, 1);
    var premonth = DateFormat.MMMM().format(prev);
    previousMonth.value = premonth;
    var response = await currentMonthLunchCount();
    if (response == 0 || response == -1) {
      print("api call error");
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('userid');
      name.value = username as String;
      // List spend=responc[]
      Set spendtime = {};
      var timeentry = response["time_entries"];
      for (var time in timeentry) {
        spendtime.add(time["spent_on"]);
      }

      //print(spendtime.length);

      currentMonthCount.value = spendtime.length;
      amount.value = spendtime.length * 10;

      //print(name.value);
      //print(responce["total_count"].runtimeType);
    }
    var prevResponse = await prevMonthLunchCount();
    if (prevResponse == 0 || prevResponse == -1) {
      print("Api error");
    } else {
      Set spendtime = {};
      var timeentry = prevResponse["time_entries"];
      for (var time in timeentry) {
        spendtime.add(time["spent_on"]);
      }
      prevMonthCount.value = spendtime.length;
      previousMonthAmount.value = spendtime.length * 10;
    }
    var isBooked = await precheck();
    if (isBooked == 0 || isBooked == -1) {
    } else {
      try {
        DateTime now = DateTime.now();
        if (isBooked["time_entries"][0]["spent_on"] ==
            DateFormat('yyyy-MM-dd').format(now).toString()) {
          this.isbooked.value = true;
        } else {
          this.isbooked.value = false;
        }
      } catch (e) {
        this.isbooked.value = false;
      }
    }
  }

  getUserCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var key = prefs.getString('key');
    return key;
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString(Appstring.loginid);
    return user;
  }

  currentMonthLunchCount() async {
    var userid = await getuserid();
    var key = await getUserCredential();
    d.log(userid);
    var endpoint = Uri.encodeFull(Resource.baseurl +
        '/projects/lunch/time_entries.json?sort=spent_on:desc&f[]=spent_on&op[spent_on]=m&f[]=user_id&op[user_id]==&v[user_id][]=$userid');

    try {
      final responce = await http.get(Uri.parse(endpoint), headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic $key",
      });
      if (responce.statusCode == 200) {
        final decodestring = jsonDecode(responce.body);
        return decodestring;
      } else {
        return 0;
      }
    } catch (e) {
      return -1;
    }
  }

  //
  prevMonthLunchCount() async {
    String? userid = await getuserid();
    var filter = 'lm';
    // https://pm.agilecyber.co.uk/projects/lunch/time_entries?utf8=✓&set_filter=1&sort=spent_on:desc&f[]=spent_on&op[spent_on]=lm&f[]=user_id&op[user_id]==&v[user_id][]=153
    // op[spent_on]=m - current month
    // op[spent_on]=lm - last month

    var url = Uri.encodeFull(Resource.baseurl +
        '/projects/lunch/time_entries.json?sort=spent_on:desc&f[]=spent_on&op[spent_on]=$filter&f[]=user_id&op[user_id]==&v[user_id][]=$userid');
    var key = await getUserCredential();
    try {
      d.log(url);

      final response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic $key",
      });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return 0;
      }
    } catch (e) {
      return -1;
    }
  }

  booklunch() {
    DateTime currentDate = DateTime.now();
    var time = DateFormat.Hm().format(currentDate);
    int hour = int.parse(time.split(":")[0]);
    int minute = int.parse(time.split(":")[1]);
    print(hour);
    print(minute);
    if (hour == 11) {
      Get.toNamed(Appstring.foodorder); //todo
      if (minute >= 30) {
        Get.snackbar("Time is up", "Book in redmine sorry for inconvenience",
            icon: Icon(Icons.close, color: Color.fromARGB(255, 165, 17, 17)),
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.FLOATING);
      } else {
        Get.offAndToNamed(Appstring.foodorder);
      }
    } else if (hour >= 12) {
      Get.toNamed(Appstring.foodorder);
      Get.snackbar("Time is up", "Book in redmine sorry for inconvenience",
          icon: Icon(Icons.close, color: Color.fromARGB(255, 165, 17, 17)),
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING);
    } else {
      Get.toNamed(Appstring.foodorder);
      //to do
      // Get.snackbar("Booking", "Book in",
      //     icon: Icon(Icons.close, color: Color.fromARGB(255, 165, 17, 17)),
      //     snackPosition: SnackPosition.TOP,
      //     snackStyle: SnackStyle.FLOATING);
    }
  }

  precheck() async {
    String? userid = await getuserid();
    var filter = 't';
    // https://pm.agilecyber.co.uk/projects/lunch/time_entries?utf8=✓&set_filter=1&sort=spent_on:desc&f[]=spent_on&op[spent_on]=lm&f[]=user_id&op[user_id]==&v[user_id][]=153
    // op[spent_on]=m - current month
    // op[spent_on]=lm - last month
    // op[spent_on]=t -today

    var url = Uri.encodeFull(Resource.baseurl +
        '/projects/lunch/time_entries.json?sort=spent_on:desc&f[]=spent_on&op[spent_on]=$filter&f[]=user_id&op[user_id]==&v[user_id][]=$userid');
    var key = await getUserCredential();
    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic $key",
      });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return 0;
      }
    } catch (e) {
      return -1;
    }
  }

  cancel() async {
    var key = await getUserCredential();
    DateTime currentDate = DateTime.now();
    var currentdate = DateFormat("yyyy-MM-dd")
        .format(DateTime(currentDate.year, currentDate.month, currentDate.day));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString(currentdate.toString());
    try {
      final response = await http.delete(
          Uri.parse(
              Resource.baseurl + Resource.lunchCancellingUrl + id! + ".json"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Basic $key",
          });
      if (response.statusCode == 204) {
        prefs.remove(currentdate.toString());
      }
    } catch (e) {
      return -1;
    }
  }
}
