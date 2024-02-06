import 'package:get/get.dart';
import 'package:test_app/pages/requests/requestcontroller.dart';

class RequestBinging extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestViewController());
  }
}
