import 'package:dp_lifecycle/struct/design_pattern.dart';

class PatternLocations {
  final Map<DesignPattern, List<List<String>>> patternLocations;

  const PatternLocations(this.patternLocations);
  factory PatternLocations.fromMap(Map<String, dynamic> json) {
    Map<DesignPattern, List<List<String>>> patternLocations = {};
    json.forEach((key, value) {
      DesignPattern pattern = stringToDP(key);
      List<List<String>> instances = (value as List<dynamic>)
          .map((e) => e.cast<String>() as List<String>)
          .toList();
      patternLocations[pattern] = instances;
    });
    return PatternLocations(patternLocations);
  }
}
