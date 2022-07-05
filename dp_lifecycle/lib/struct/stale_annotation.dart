import 'package:dp_lifecycle/struct/annotation.dart';

class StaleAnnotation extends Annotation {
  final int start, end;
  final List<String> files;

  StaleAnnotation(
      {required String patternInstance,
      required this.start,
      required this.end,
      required this.files})
      : super(
            annotationType: AnnotationType.stale,
            patternInstance: patternInstance);

  factory StaleAnnotation.fromMap(Map<String, dynamic> json) {
    return StaleAnnotation(
        patternInstance: json['instance'],
        start: json['start'],
        end: json['end'],
        files: json['files'].toString().split(','));
  }
}
