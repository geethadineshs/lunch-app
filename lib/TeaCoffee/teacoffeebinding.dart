import 'package:get/get.dart';
import 'teacoffeecontroller.dart';

class TeaCoffeeBinging extends Bindings{
  @override
  void dependencies() {
     Get.lazyPut(() => TeaCoffeeController());
  }
  }

