import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/providers/lifecycle_provider.dart';
import 'package:get/instance_manager.dart';

class LifecycleBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<LifecycleProvider>(LifecycleProvider());
    Get.put<UIController>(UIController());
    Get.put<TimelineController>(TimelineController());
    Get.put<LifecycleController>(LifecycleController());
  }
}
