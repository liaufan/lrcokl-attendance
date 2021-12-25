import 'package:get/get.dart';
import 'package:lrcokl/controllers/attendance.controller.dart';
import 'package:lrcokl/controllers/update.comtroller.dart';

class GetInitializer extends Bindings {
  @override
  void dependencies() {
    // these controllers are yet to be initiallized
    // they will be initialized when they are referenced
    Get.put<AttendanceController>(AttendanceController());
    Get.put<UpdateController>(UpdateController());
  }
}
