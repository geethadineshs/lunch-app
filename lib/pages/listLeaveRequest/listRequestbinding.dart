import 'package:get/get.dart';
import 'package:test_app/pages/leaverequest/leaverequestcontroller.dart';

class LeaveRequestListbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaveRequestController());
  }
}
