import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/providers/lifecycle_provider.dart';
import 'package:get/instance_manager.dart';

class LifecycleBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<LifecycleProvider>(LifecycleProvider());
    Get.put<LifecycleController>(LifecycleController());
  }
}
