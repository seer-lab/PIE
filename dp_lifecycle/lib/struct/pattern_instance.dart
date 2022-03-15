import 'package:code_editor/code_editor.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:dp_lifecycle/struct/file_history.dart';
import 'package:dp_lifecycle/struct/interval.dart';

class PatternInstance {
  final String name;
  DesignPattern pattern = DesignPattern.na;
  final List<String> files;
  final List<Interval> intervals;
  FileHistory? fileHistory;

  PatternInstance(this.name, this.intervals)
      : files = name.split('-')..removeLast() {
    pattern = getDesignPattern();
  }

  factory PatternInstance.fromMap(String name, List<dynamic> json) {
    return PatternInstance(name,
        json.map((e) => Interval.fromMap(e as Map<String, dynamic>)).toList());
  }

  List<Interval> getPatternInterval() {
    return intervals
        .where((element) => element.modificationCommit == 'Pattern')
        .toList();
  }

  List<Interval> getPatternBreaks({String filename = ''}) {
    return intervals
        .where((element) =>
            element.modificationCommit == 'break' &&
            (filename == '' || element.instance.split('-').contains(filename)))
        .toList();
  }

  List<Interval> getFileInterval(String file) {
    return intervals
        .where((element) =>
            element.instance.split(' ')[0] == file &&
            element.modificationCommit != 'Pattern')
        .toList();
  }

  DesignPattern getDesignPattern() {
    DesignPattern ans = DesignPattern.na;
    intervals.forEach((element) {
      if (element.modificationCommit == 'Pattern') {
        ans = stringToDP(element.data['pattern']);
        return;
      }
    });
    return ans;
  }

  Map<String, String> findCommitToFiles(int commit) {
    Map<String, String> ans = {};
    intervals.forEach((element) {
      if (element.end > commit &&
          element.start < commit &&
          !element.isPattern) {
        ans[element.fileName] = element.modificationCommit;
      }
    });
    return ans;
  }

  List<FileEditor>? getFilesAtCommit(int commit) {
    if (fileHistory == null) return null;
    List<FileEditor> ans = [];

    Map<String, String> targets = findCommitToFiles(commit);
    targets.entries.forEach((element) {
      String? content = fileHistory!.getFile(element.value, element.key);
      if (content != null) {
        ans.add(FileEditor(name: element.key, language: 'java', code: content));
      }
    });
    return ans;
  }

  Interval? getIntervalAtCommit(int commit) {
    Interval? ans;
    intervals.forEach((element) {
      if (element.end > commit &&
          element.start < commit &&
          !element.isPattern) {
        ans = element;
      }
    });
    return ans;
  }
}
