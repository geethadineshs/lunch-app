import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/const/stringconst.dart';
import 'package:video_player/video_player.dart';

class RequestViewController extends GetxController {
  late VideoPlayerController videoController;

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString(Appstring.loginid);
    return user;
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
