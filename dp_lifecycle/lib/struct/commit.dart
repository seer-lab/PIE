import 'package:dp_lifecycle/struct/PinotData.dart';
import 'package:dp_lifecycle/struct/pattern_locations.dart';

class Commit {
  final String hash, message, author, date;
  final bool isMerge;
  final int numLines, numFiles;
  final List<String> modifiedFiles;
  final Map<String, int> dpSummary;
  PatternLocations patternLocations;
  PinotData pinotData;

  Commit(
      {required this.hash,
      required this.message,
      required this.author,
      required this.date,
      required this.isMerge,
      required this.numLines,
      required this.numFiles,
      required this.modifiedFiles,
      required this.dpSummary,
      required this.patternLocations,
      required this.pinotData});

  factory Commit.fromMap(Map<String, dynamic> json) {
    return Commit(
        hash: json['_id'],
        message: json['msg'],
        author: json['author'],
        date: json['date'],
        isMerge: json['merge'],
        numLines: json['lines'],
        numFiles: json['files'],
        modifiedFiles: json['modified_files'].cast<String>(),
        dpSummary: json['summary'].cast<String, int>(),
        patternLocations: PatternLocations.fromMap(
            json['pattern_locations'] as Map<String, dynamic>),
        pinotData: PinotData.fromMap(
            json['pattern_locations'] as Map<String, dynamic>));
  }
}
