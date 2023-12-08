import 'package:get/get.dart';
import '../MenuList/menulistcontroller.dart';
import '../home/homecontroller.dart';
import 'splashcontroller.dart';

class SplashBinding extends Bindings
{
  @override
  void dependencies() {
   Get.lazyPut(() => SplashController());
   Get.lazyPut(()=>Homecontroller());
   Get.lazyPut(() => MenuListController());

  //  Get.lazyPut(()=>TeaCoffeeController());
  }

}