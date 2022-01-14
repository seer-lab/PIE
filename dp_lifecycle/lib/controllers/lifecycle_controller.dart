import 'package:dp_lifecycle/providers/lifecycle_provider.dart';
import 'package:dp_lifecycle/struct/interval.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class LifecycleController extends GetxController
    with StateMixin<List<PatternInstance>> {
  final LifecycleProvider _provider = LifecycleProvider();

  @override
  void onInit() {
    super.onInit();
    _provider.getIntervals('Strategy').then((value) {
      change(value, status: RxStatus.success());
    }, onError: (err) {
      change([], status: RxStatus.error(err.toString()));
    });
  }

  void onUpdatePattern(String pattern) {
    change([], status: RxStatus.loading());
    _provider.getIntervals(pattern).then((value) {
      change(value, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }
}
