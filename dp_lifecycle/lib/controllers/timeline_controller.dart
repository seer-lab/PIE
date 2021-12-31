import 'package:dp_lifecycle/providers/lifecycle_provider.dart';
import 'package:dp_lifecycle/struct/commit.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class TimelineController extends GetxController {
  List<Commit> commits = <Commit>[].obs;
  RxInt previewStart = 0.obs, previewEnd = 0.obs;
  int previewMarker = 0;

  final LifecycleProvider _provider = LifecycleProvider();
  @override
  void onInit() {
    super.onInit();
    _provider.getCommits().then((value) {
      commits = value;
      previewEnd = commits.length.obs;
    }, onError: (err) {
      print(err);
    });
  }

  double normalizedPosition(int commitNumber) {
    if (commitNumber < previewStart.value) return 0;
    if (commitNumber > previewEnd.value) return 1;
    return (commitNumber - previewStart.value) /
        (previewEnd.value - previewStart.value);
  }

  int positionToCommit(double value) {
    return (value * commits.length).round();
  }

  void updatePreviewEnd(int value) {
    previewEnd = value.obs;
    update();
  }

  void updatePreviewStart(int value) {
    previewStart = value.obs;
    update();
  }
}
