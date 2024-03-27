import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/const/stringconst.dart';
import '../../const/resourceconst.dart';

class LeaveRequestController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final commentController = TextEditingController();
  var selectedLeaveType = "".obs;
  RxList mainiteams = [].obs;
  List selectedItems = [];
  var extra = ''.obs;
  var name = "".obs;
  var lastname = "".obs;
  var userid = "".obs;
  var noselected = 'chapathi'.obs;
  var selected = "".obs;


/// The function `onLeaveTypeSelected` prints the selected value and checks if it is the first item in
/// the `leaveTypes` list.
/// 
/// Args:
///   value (String): The value parameter is a string that represents the selected leave type.
  void onLeaveTypeSelected(String value) {
    print('Selected value: $value');

    if (value == leaveTypes.isNotEmpty ? leaveTypes[0]['value'] : null) {
      print('First item selected');
    } else {
      print('Other item selected');
    }
  }

/// The `oninit` function retrieves user information from shared preferences and assigns it to
/// variables.
  oninit() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('userid');

    var user = prefs.getString(Appstring.loginid);
    userid.value = user as String;
    name.value = username as String;
    lastname.value = prefs.getString(Appstring.lastname)!;
    print(userid.value);
    print(name.value);
  }

  /// The function sets the value of a variable called "selectedLeaveType" to the provided value.
  /// 
  /// Args:
  ///   value (String): The value parameter is a string that represents the selected leave type.
  void setSelectedLeaveType(String value) {
    selectedLeaveType.value = value;
  }


  /// The `submitLeaveRequest` function is responsible for validating and submitting a leave request
  /// with the provided request body.
  /// 
  /// Args:
  ///   requestBody (Map<String, dynamic>): The requestBody parameter is a Map<String, dynamic> that
  /// contains the data for the leave request. It should include the necessary information such as the
  /// start date, end date, and comments for the leave request.
  void submitLeaveRequest(Map<String, dynamic> requestBody) async {
    if (formKey.currentState!.validate()) {

      String requestBodyJson = jsonEncode(requestBody);
      var key = await getusercredential();

      try {
        var response = await http.post(
          Uri.parse(Resource.baseurl + Resource.leaveRequest),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Basic $key",
          },
          body: requestBodyJson,
        );

        if (response.statusCode == 200) {
          print('Leave request submitted successfully');
          Get.snackbar(
            '', 
            'Leave request submitted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color.fromARGB(255, 34, 2, 74),
            colorText: Colors.white,
            messageText: Text(
              'Leave request submitted successfully',
              textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 2), 
          );
          Get.offNamed('/home');


          Future.delayed(Duration(seconds: 2), () {
            startDateController.clear();
            endDateController.clear();
            commentController.clear(); 
          });

        } else {
          Get.snackbar(
            'Error',
            'Failed to submit leave request: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM,
          );
          print('Response body: ${response.body}');
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Exception occurred while submitting leave request: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  /// The function `getuserid()` retrieves the user ID from shared preferences in Dart.
  /// 
  /// Returns:
  ///   the user ID as a string.
  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString(Appstring.loginid);
    return user;
  }

/// The function `getusercredential()` retrieves a user's credential from shared preferences in Dart.
/// 
/// Returns:
///   The value of the 'key' stored in the SharedPreferences.
  getusercredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var key = prefs.getString('key');
    return key;
  }

  var leaveTypes = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveTypes(); 
  }


  void fetchLeaveTypes() async {
    var key = await getusercredential();

    try {
      final response = await http.get(
        Uri.parse(
            'https://pm.agilecyber.co.uk/wkleaverequest/getLeaveType.json'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Basic $key",
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        leaveTypes
            .assignAll(data); 
        if (leaveTypes.isNotEmpty) {
          selectedLeaveType.value = leaveTypes[0]['value'].toString();
        }
      } else {
        throw Exception(
            'Failed to load leave types. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching leave types: $e');
    }
  }
}




