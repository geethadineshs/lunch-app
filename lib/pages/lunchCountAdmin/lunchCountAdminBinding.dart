import 'package:get/get.dart';

import 'lunchCountAdminController.dart';

class LunchCountingAdminbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LunchCountingAdminController());
  }
}
