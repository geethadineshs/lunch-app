import 'package:get/get.dart';

import 'logincontroller.dart';

class Loginbinding extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }

}