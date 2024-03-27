import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/const/Appcolor.dart';

import '../../const/resourceconst.dart';
import '../../const/stringconst.dart';

class LoginController extends GetxController {
  // Obtain shared preferences.
  var deletetext = false.obs;
  var showpassword = false.obs;

  var loader = true.obs;
  var error = false.obs;
  final FocusNode usernameFocus = FocusNode();

  errormessage() {
    error.toggle();
  }

  void updateDeleteText(bool value) {
    deletetext.value = value;
  }

  var hasPasswordText = false.obs;

  void togglePasswordVisibility() {
    if (hasPasswordText.value) {
      showpassword.value = !showpassword.value;
    } else {
      showpassword.value = false;
    }
  }

  void updatePasswordText(bool hasText) {
    hasPasswordText.value = hasText;
  }

  makepasswordshoworhide() {
    showpassword.toggle();
  }

  removetext() {
    deletetext.toggle();
  }

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  formsubmit(user, pass) async {
    loader.toggle();
    var key = keygenration(user, pass);
    var responce = await apicall(key);

    if (responce == 0 || responce == -1) {
      loader.toggle();
      username.text = "";
      password.text = "";
      if (responce == -1) {
        Get.snackbar("Error", "invalid No network ",
            icon: Icon(Icons.close, color: Color.fromARGB(255, 165, 17, 17)),
            snackPosition: SnackPosition.TOP,
            snackStyle: SnackStyle.FLOATING);
      } else {
        Get.snackbar(
          "Error",
          "Invalid username or password",
          icon: Icon(
            Icons.close,
            color: Color.fromARGB(255, 165, 17, 17),
          ),
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: AppColors.button,
        );
      }
    } else {
      var name = responce["user"]["firstname"];
      var lastname = responce["user"]["lastname"];

      var id = responce['user']['id'].toString();

      loader.toggle();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Appstring.userkey, key);
      prefs.setString(Appstring.userid, name);
      prefs.setString(Appstring.loginid, id);
      prefs.setString(Appstring.lastname, lastname);
      Get.offAllNamed(Appstring.home);
      Get.offAllNamed(Appstring.deletedEntries);
    }
    //(Appstring.home);
  }
}

keygenration(username, password) {
  var key = base64.encode(utf8.encode(username + ":" + password));
  return key;
}

apicall(key) async {
  try {
    final responce = await http.get(
        Uri.parse(
          Resource.baseurl + Resource.loginendpoint,
        ),
        headers: {
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
