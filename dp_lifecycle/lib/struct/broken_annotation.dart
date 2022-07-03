import 'package:dp_lifecycle/struct/annotation.dart';

class BrokenAnnotation extends Annotation {
  final int commit;
  final List<String> files;

  BrokenAnnotation(
      {required String patternInstance,
      required this.commit,
      required this.files})
      : super(
            annotationType: AnnotationType.broken,
            patternInstance: patternInstance);

  factory BrokenAnnotation.fromMap(Map<String, dynamic> json) {
    return BrokenAnnotation(
        patternInstance: json['instance'],
        commit: json['commit'],
        files: json['files'].toString().split(','));
  }
}
