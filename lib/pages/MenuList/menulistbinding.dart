import 'package:get/get.dart';
import 'menulistcontroller.dart';

class LunchBinging extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuListController());
  }
}
