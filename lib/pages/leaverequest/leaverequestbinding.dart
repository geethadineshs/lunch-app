import 'package:get/get.dart';
import 'package:test_app/pages/leaverequest/leaverequestcontroller.dart';

class LeaveRequestBinging extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaveRequestController());
  }
}
