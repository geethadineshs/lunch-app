import 'package:get/get.dart';
import 'package:test_app/pages/requests/requestcontroller.dart';

import '../home/homecontroller.dart';

class RequestBinging extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestViewController());
    Get.lazyPut(() => Homecontroller());

  }
}
