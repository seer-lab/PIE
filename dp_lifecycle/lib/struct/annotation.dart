import 'package:dp_lifecycle/struct/broken_annotation.dart';
import 'package:dp_lifecycle/struct/stale_annotation.dart';
import 'package:dp_lifecycle/struct/start_annotation.dart';

enum AnnotationType { start, broken, stale }

extension ToAnnotationType on String {
  AnnotationType? toAnnotationType() {
    final Map<String, AnnotationType> mapping = {
      "start": AnnotationType.start,
      "break": AnnotationType.broken,
      "stale": AnnotationType.stale,
    };
    if (!mapping.containsKey(this)) {
      return null;
    }
    return mapping[this]!;
  }
}

abstract class Annotation {
  final AnnotationType annotationType;
  final String patternInstance;

  Annotation({required this.annotationType, required this.patternInstance});

  factory Annotation.fromMap(Map<String, dynamic> json) {
    switch (json['modification'].toString().toAnnotationType()!) {
      case AnnotationType.broken:
        return BrokenAnnotation.fromMap(json);
      case AnnotationType.start:
        return StartAnnotation.fromMap(json);
      case AnnotationType.stale:
        return StaleAnnotation.fromMap(json);
    }
  }
}
