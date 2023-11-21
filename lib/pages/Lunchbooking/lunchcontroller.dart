import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../const/resourceconst.dart';
import '../../const/stringconst.dart';

class LunchController extends GetxController {
  var isbooked = false.obs;
  var isloading = false.obs;

  get selectedDish => null;

  get extraDish => null;
  booked() {
    // isbooked.toggle();
  }

  var noselected = 'chapathi'.obs;
  var selected = "".obs;
  var extra = ''.obs;
  var getbody;
  RxList mainiteams = [].obs;
  RxList extraiteam = [].obs;
  List selectedItems=[];
  Rx<TextEditingController> startdate = TextEditingController().obs;
  Rx<TextEditingController> enddate = TextEditingController().obs;
// Define a variable to hold the selected values
  List<String> selectedValues = [];
  booklunch(selectedDateStrings) async {
    var foodoption = mainiteams.indexOf(selected.value) + 1;
    var extra = selectedItems;    
      print('Selected Values outside widget: $selectedValues');
    

    var key = await getusercredential();
    for (var i in selectedDateStrings) {
      var body = jsonEncode(postbody(foodoption, extra, i));

      // print(body.runtimeType);
      print(body);
      //  print("Booking date: $i");
      // print("Date: $i");
      try {
        final response = await http.post(
          Uri.parse(
            Resource.baseurl + Resource.booking,
          ),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Basic $key",
          },
          body: body,
        );
        //print(await response);

        if (response.statusCode == 200) {
          // DateTime currentDate = DateTime.now();
          // var currentdate = DateFormat("yyyy-MM-dd").format(
          //     DateTime(currentDate.year, currentDate.month, currentDate.day));
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // await prefs.setString(currentdate.toString(), currentdate.toString());
          //return response.statusCode;
        } else {
          //return response.statusCode;
          // print("Failed to book date: $i (Status Code: ${response.statusCode})");
        }
      } catch (e) {
        // print("Error while booking date: $i ($e)");
        return -1;
      }
    }
  }

  init() async {
    var responce = await _menuapi();
    var costumfile = responce["custom_fields"];
    // var maindish= costumfile["id"];
    var mainoptions = await costumfile.firstWhere((item) {
      return item['id'] == 41;
    });
    var extraoption = await costumfile.firstWhere((item) {
      return item['id'] == 47;
    });

    var mainfooditem = mainoptions["possible_values"];
    var extrafooditem = extraoption["possible_values"];
    print(mainfooditem.length);
    print(extrafooditem.length);
    for (var item in mainfooditem) {
      var labeitem = item["label"];
      mainiteams.add(labeitem);
    }
    for (var extra in extrafooditem) {
      var labeitem = extra["label"];
      extraiteam.add(labeitem);
    }
  }

  getusercredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var key = prefs.getString('key');
    return key;
  }

  postbody(
    foodcode,
    extra,
    startDate,
  ) {
    return {
      "time_entry": {
        "project_id": 342,
        "hours": 0,
        "activity_id": 16,
        "spent_on": startDate,
        "custom_fields": [
          {"id": 39, "value": 1},
          {"id": 41, "value": foodcode},
          {"id": 59, "value": "Non Billable"},
          {"id": 47, "value": extra},
        ],
        "comments": ""
      }
    };
  }

  cancel() async {
    var key = await getusercredential();
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
        booked();
      }
    } catch (e) {
      return -1;
    }
  }

  _menuapi() async {
    print(_menuapi);
    try {
      final responce = await http.get(
          Uri.parse(
            Resource.baseurl + Resource.menuiteam,
          ),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Basic YXBpX3VzZXI6QWNzQDIwMTc=",
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

  precheck() async {
    String? userid = await getuserid();
    var prevMonth = 't';
    // https://pm.agilecyber.co.uk/projects/lunch/time_entries?utf8=✓&set_filter=1&sort=spent_on:desc&f[]=spent_on&op[spent_on]=lm&f[]=user_id&op[user_id]==&v[user_id][]=153
    // op[spent_on]=m - current month
    // op[spent_on]=lm - last month
    // op[spent_on]=t -today

    var endpoint = Uri.encodeFull(Resource.baseurl +
        '/projects/lunch/time_entries.json?sort=spent_on:desc&f[]=spent_on&op[spent_on]=$prevMonth&f[]=user_id&op[user_id]==&v[user_id][]=$userid');
    var key = await getusercredential();
    try {
      final responce = await http.get(Uri.parse(endpoint), headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic $key",
      });
      if (responce.statusCode == 200) {
        return json.decode(responce.body);
      } else {
        return 0;
      }
    } catch (e) {
      return -1;
    }
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString(Appstring.loginid);
    return user;
  }
}
