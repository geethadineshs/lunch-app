import 'package:get/get.dart';
import '../Lunchbooking/lunchcontroller.dart';
import 'homecontroller.dart';

class Homebinging extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Homecontroller());
    Get.lazyPut(() => LunchController());

  }
}
