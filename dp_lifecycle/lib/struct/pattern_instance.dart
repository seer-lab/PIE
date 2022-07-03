import 'package:dp_lifecycle/struct/annotation.dart';
import 'package:dp_lifecycle/struct/broken_annotation.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:dp_lifecycle/struct/file_history.dart';
import 'package:dp_lifecycle/struct/interval.dart';
import 'package:dp_lifecycle/struct/modified_file.dart';

class PatternInstance {
  final String name;
  DesignPattern pattern = DesignPattern.na;
  final List<String> files;
  final List<Interval> intervals;
  final List<Annotation> annotations;
  FileHistory? fileHistory;

  PatternInstance(this.name, this.intervals, this.annotations)
      : files = name.split('-')..removeLast() {
    pattern = getDesignPattern();
  }

  factory PatternInstance.fromMap(
      String name, List<dynamic> json, List<Annotation> annotations) {
    return PatternInstance(
        name,
        json.map((e) => Interval.fromMap(e as Map<String, dynamic>)).toList(),
        annotations);
  }

  List<Interval> getPatternInterval() {
    return intervals
        .where((element) => element.modificationCommit == 'Pattern')
        .toList();
  }

  List<BrokenAnnotation> getPatternBreaks({String filename = ''}) {
    List<BrokenAnnotation> brokenAnnotations =
        annotations.whereType<BrokenAnnotation>().toList();

    if (filename == '') {
      return brokenAnnotations;
    }
    return brokenAnnotations
        .where((element) => element.files.contains(filename))
        .toList();
  }

  List<Interval> getFileInterval(String file) {
    return intervals
        .where((element) =>
            element.instance.split(' ')[0] == file &&
            element.modificationCommit != 'Pattern' &&
            element.modificationCommit != 'break')
        .toList();
  }

  DesignPattern getDesignPattern() {
    DesignPattern ans = DesignPattern.na;
    for (Interval element in intervals) {
      if (element.modificationCommit == 'Pattern') {
        ans = stringToDP(element.data['pattern']);
        break;
      }
    }
    return ans;
  }

  Map<String, String> findCommitToFiles(int commit) {
    Map<String, String> ans = {};
    for (Interval element in intervals) {
      if (element.end > commit &&
          element.start <= commit &&
          !element.isPattern) {
        ans[element.fileName] = element.modificationCommit;
      }
    }
    return ans;
  }

  List<ModifiedFile>? getFilesAtCommit(int commit) {
    if (fileHistory == null) return null;
    List<ModifiedFile> ans = [];

    Map<String, String> targets = findCommitToFiles(commit);
    for (MapEntry<String, String> element in targets.entries) {
      ModifiedFile? content = fileHistory!.getFile(element.value, element.key);
      if (content != null) {
        ans.add(content);
      }
    }
    return ans;
  }

  Interval? getIntervalAtCommit(int commit) {
    Interval? ans;
    for (Interval element in intervals) {
      if (element.end > commit &&
          element.start < commit &&
          !element.isPattern) {
        ans = element;
      }
    }
    return ans;
  }
}
