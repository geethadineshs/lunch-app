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
  RxString selectedValue = "Tea - Morning".obs;

  void setSelectedValue(String value) {
    selectedValue.value = value;
  }

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
  List selectedItems = [];
  Rx<TextEditingController> startdate = TextEditingController().obs;
  Rx<TextEditingController> enddate = TextEditingController().obs;
// Define a variable to hold the selected values
  List<String> selectedValues = [];
  booklunch(selectedDateStrings, deletedEntries) async {
    var foodoption = mainiteams.indexOf(selected.value) + 1;
    var extra = selectedItems;
    print('Selected Values outside widget: $selectedValues');

    var key = await getusercredential();
    var count = 0;

    for (var i in selectedDateStrings) {
      count++;
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
          if (selectedDateStrings.length == count) {
            return response.statusCode;
          }
        } else {
          return response.statusCode;
        }
      } catch (e) {
        print(e);
        return e;
        // print("Error while booking date: $i ($e)");
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

  bool isDateAlreadyBooked = false;
Future<Map<String, dynamic>> getTodaLunch(BuildContext context) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userid = await getuserid();
  var filter = 't';
  var currentDate = DateTime.now();
  var formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);

  var url = Uri.encodeFull(Resource.baseurl +
      Resource.lunchcountapi +
      'sort=spent_on:desc&f[]=spent_on&op[spent_on]=$filter&f[]=user_id&op[user_id]==&v[user_id][]=$userid&f[]=&c[]=spent_on&c[]=user&c[]=activity&c[]=issue&c[]=comments&c[]=hours&c[]=cf_59&c[]=cf_63&c[]=project&group_by=cf_41&t[]=hours&t[]=&spent_type=T');
  print("url $url");
  var key = await getusercredential();

  try {
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Basic $key",
    });

    if (response.statusCode == 200) {
      // Parse the response correctly
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));

      // Check if today's date is in the response
      if (jsonResponse['time_entries'].any((entry) =>
          DateFormat('yyyy-MM-dd').format(DateTime.parse(entry['spent_on'])) ==
          formattedCurrentDate)) {
        // Date is already booked, set the flag.
        print('Date already booked. Show alert message.');
        
        // Perform actions or show alerts to inform the user
        // Example: Show an alert
        // showDateAlreadyBookedAlert(context);
        
        // Alternatively, you can return an error message or throw an exception
        return {'isDateAlreadyBooked': true};
      }

      // Date is not booked
      return {'isDateAlreadyBooked': false};
    } else {
      // Failed to fetch data
      return {'error': 'Failed to fetch data'};
    }
  } catch (e) {
    print("Exception occurred: $e");
    return {'error': 'Exception occurred: $e'};
  }
}


  checkIfDateExists(selectedDateStrings) {}
}
