import 'package:dp_lifecycle/struct/interval.dart';

class PatternInstance {
  final String name, pattern;
  final List<String> files;
  final List<Interval> intervals;

  PatternInstance(this.name, this.pattern, this.intervals)
      : files = name.split('-');

  factory PatternInstance.fromMap(
      String name, String pattern, List<dynamic> json) {
    return PatternInstance(name, pattern,
        json.map((e) => Interval.fromMap(e as Map<String, dynamic>)).toList());
  }
}
