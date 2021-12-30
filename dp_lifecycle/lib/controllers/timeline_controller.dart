import 'package:dp_lifecycle/providers/lifecycle_provider.dart';
import 'package:dp_lifecycle/struct/commit.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class TimelineController extends GetxController {
  List<Commit> commits = <Commit>[].obs;
  int previewStart = 0, previewEnd = 0;
  int previewMarker = 0;

  final LifecycleProvider _provider = LifecycleProvider();
  @override
  void onInit() {
    super.onInit();
    _provider.getCommits().then((value) {
      commits = value;
      previewStart = 0;
      previewMarker = 0;
      previewEnd = commits.length;
    }, onError: (err) {
      print(err);
    });
  }
}
