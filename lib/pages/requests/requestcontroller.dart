import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/const/stringconst.dart';

class RequestViewController extends GetxController {
  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString(Appstring.loginid);
    return user;
  }
}
