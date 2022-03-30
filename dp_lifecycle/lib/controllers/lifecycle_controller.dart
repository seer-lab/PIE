import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/providers/lifecycle_provider.dart';
import 'package:dp_lifecycle/struct/interval.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/struct/project.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class LifecycleController extends GetxController
    with StateMixin<List<PatternInstance>> {
  final LifecycleProvider _provider = LifecycleProvider();
  String lastPattern = "Strategy";
  @override
  void onInit() {
    super.onInit();
    Project project = Get.find<TimelineController>().selectedProject.value;
    _provider.getIntervals(project, 'Strategy').then((value) {
      change(value, status: RxStatus.success());
    }, onError: (err) {
      change([], status: RxStatus.error(err.toString()));
    });
  }

  void onUpdatePattern(String pattern) {
    lastPattern = pattern;
    Project project = Get.find<TimelineController>().selectedProject.value;
    change([], status: RxStatus.loading());
    _provider.getIntervals(project, pattern).then((value) {
      change(value, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void onRefresh() {
    change([], status: RxStatus.loading());
    Project project = Get.find<TimelineController>().selectedProject.value;
    _provider.getIntervals(project, lastPattern).then((value) {
      change(value, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void onUnload() {
    change([], status: RxStatus.loading());
  }
}
