import 'package:code_editor/code_editor.dart';
import 'package:dp_lifecycle/providers/lifecycle_provider.dart';
import 'package:dp_lifecycle/struct/commit.dart';
import 'package:dp_lifecycle/struct/file_history.dart';
import 'package:dp_lifecycle/struct/file_view_style.dart';
import 'package:dp_lifecycle/struct/modified_file.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/struct/project.dart';
import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';

class TimelineController extends GetxController {
  List<Commit> commits = <Commit>[].obs;
  Map<String, int> commitHashIndex = {};
  RxInt previewStart = 0.obs, previewEnd = 1.obs;
  RxInt previewMarker = 0.obs;
  Rx<FileViewStyle> fileViewStyle = Rx<FileViewStyle>(FileViewStyle.combined);

  Rx<PatternInstance>? selectedPattern;
  Rx<Project> selectedProject = Rx<Project>(
      Project(projectStatus: ProjectStatus.ready, name: 'jhotdraw'));

  final LifecycleProvider _provider = LifecycleProvider();
  @override
  void onInit() {
    super.onInit();
    _provider.getCommits(selectedProject.value).then((value) {
      commits = value;
      previewEnd = commits.length.obs;
      previewStart = 0.obs;
      previewMarker = 1.obs;

      for (int i = 0; i < commits.length; i++) {
        commitHashIndex[commits[i].hash] = i;
      }
      update();
    }, onError: (err) {
      if (kDebugMode) {
        print(err);
      }
    });
  }

  double normalizedPosition(int commitNumber) {
    if (commitNumber < previewStart.value) return 0;
    if (commitNumber > previewEnd.value) return 1;
    return (commitNumber - previewStart.value) /
        (previewEnd.value - previewStart.value);
  }

  Future<FileHistory> getFileHistory(PatternInstance instance) async {
    FileHistory history = await _provider.getFileHistory(
        selectedProject.value, instance.pattern, instance.name);
    return history;
  }

  Future<List<Project>> getProjects() async {
    List<Project> projects = await _provider.getProjects();
    return projects;
  }

  Future<bool> onSelectProject(Project project) async {
    selectedProject = Rx<Project>(project);
    previewStart = 0.obs;
    previewMarker = 1.obs;
    selectedPattern = null;
    commits = [];
    update();
    List<Commit> value = await _provider.getCommits(project);
    commits = value;
    previewEnd = commits.length.obs;
    update();
    return true;
  }

  List<ModifiedFile> getFiles() {
    if (selectedPattern == null) {
      return [];
    }
    List<ModifiedFile>? ans =
        selectedPattern!.value.getFilesAtCommit(previewMarker.value);
    if (ans == null) return [];
    return ans;
  }

  ModifiedFile getFileAtCommit(String name, String commit) {
    if (selectedPattern == null || !commitHashIndex.containsKey(commit)) {
      return ModifiedFile('file', 'Something went wrong.');
    }
    List<ModifiedFile> files =
        selectedPattern!.value.getFilesAtCommit(commitHashIndex[commit]! + 1) ??
            [];
    for (int i = 0; i < files.length; i++) {
      print(files[i].name + ' - ' + name);
      if (files[i].name == name) {
        return files[i];
      }
    }
    return ModifiedFile('file', 'Could not find previous version');
  }

  String getPinotInfo() {
    if (selectedPattern == null) {
      return "Please Select a Pattern Instance Card to view it's Pinot Information";
    }
    if (commits[previewMarker.value]
        .pinotData
        .pinotData
        .containsKey(selectedPattern!.value.name)) {
      return commits[previewMarker.value]
          .pinotData
          .pinotData[selectedPattern!.value.name]!;
    }
    return "No Pinot data exists at this commit.";
  }

  Commit getCommit() {
    return commits[previewMarker.value];
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

  void updatePreviewMarker(int value) {
    previewMarker = value.obs;
    update();
  }

  void updateSelectedPattern(PatternInstance? instance) {
    if (instance == null) {
      selectedPattern = null;
    } else {
      selectedPattern = Rx<PatternInstance>(instance);
    }
    update();
  }

  void updateFileViewStyle(FileViewStyle? style) {
    if (style == null) return;
    fileViewStyle = Rx<FileViewStyle>(style);
    update();
  }
}
