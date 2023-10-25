import 'package:get/get.dart';
import 'lunchcontroller.dart';

class LunchBinging extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => LunchController());
  }

}