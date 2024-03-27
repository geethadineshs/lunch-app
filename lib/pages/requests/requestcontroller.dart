import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/const/stringconst.dart';
import 'package:video_player/video_player.dart';

import '../../const/resourceconst.dart';
import '../MenuList/menulistcontroller.dart';

class RequestViewController extends GetxController {
  late VideoPlayerController videoController;

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString(Appstring.loginid);
    return user;
  }

Future<bool> isAdmin() async {
  var key = await getusercredential();
  var endpoint = Uri.encodeFull(Resource.baseurl + '/acsapi/public/redmine/user');
  
  try {
    final response = await http.get(Uri.parse(endpoint), headers: {
      "Content-Type": "application/json",
      "Authorization": "Basic $key",
    });

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final isAdmin = decodedResponse['user']['admin'] ?? false; // Extract admin status or default to false if not present
      return isAdmin;
    } else {
      // Handle other status codes if needed
      return false;
    }
  } catch (e) {
    // Handle errors
    return false;
  }
}


  var name = "".obs;
  var lastname = "".obs;

  @override
  void onInit() {
    super.onInit();
    videoController = VideoPlayerController.asset('assets/demo.mp4')
      ..initialize().then((_) {
        videoController.setLooping(true);
        videoController.play();
        update();
      });
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
