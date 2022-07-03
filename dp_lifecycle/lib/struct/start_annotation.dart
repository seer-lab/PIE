import 'package:dp_lifecycle/struct/annotation.dart';

class StartAnnotation extends Annotation {
  final int commit;
  final List<String> files;

  StartAnnotation(
      {required String patternInstance,
      required this.commit,
      required this.files})
      : super(
            annotationType: AnnotationType.broken,
            patternInstance: patternInstance);

  factory StartAnnotation.fromMap(Map<String, dynamic> json) {
    return StartAnnotation(
        patternInstance: json['instance'],
        commit: json['commit'],
        files: json['files'].toString().split(','));
  }
}
