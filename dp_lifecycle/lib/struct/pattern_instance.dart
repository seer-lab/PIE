import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:dp_lifecycle/struct/interval.dart';

class PatternInstance {
  final String name;
  final DesignPattern pattern;
  final List<String> files;
  final List<Interval> intervals;

  PatternInstance(this.name, this.pattern, this.intervals)
      : files = name.split('-');

  factory PatternInstance.fromMap(
      String name, String pattern, List<dynamic> json) {
    return PatternInstance(name, stringToDP(pattern),
        json.map((e) => Interval.fromMap(e as Map<String, dynamic>)).toList());
  }

  List<Interval> getPatternInterval() {
    return intervals
        .where((element) => element.modificationCommit == 'Pattern')
        .toList();
  }

  List<Interval> getFileInterval(String file) {
    return intervals
        .where((element) => element.instance.split(' ')[0] == file)
        .toList();
  }
}
