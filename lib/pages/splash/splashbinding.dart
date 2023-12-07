import 'package:get/get.dart';
import 'package:test_app/TeaCoffee/teacoffeecontroller.dart';
import '../home/homecontroller.dart';
import 'splashcontroller.dart';

class SplashBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => SplashController());
   Get.lazyPut(()=>Homecontroller());
   Get.lazyPut(()=>TeaCoffeeController());
  }

}