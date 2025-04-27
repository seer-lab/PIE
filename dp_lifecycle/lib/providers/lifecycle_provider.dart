import 'dart:convert';
import 'package:dp_lifecycle/struct/annotation.dart';
import 'package:dp_lifecycle/struct/commit.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:dp_lifecycle/struct/file_history.dart';
import 'package:dp_lifecycle/struct/modified_file.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/struct/project.dart';
import 'package:get/get_connect.dart';
import 'package:http/http.dart' as http;

class LifecycleProvider extends GetConnect {
  //String uri = "seerlab.ca";
  String uri = "localhost";
  Future<List<PatternInstance>> getIntervals(
      Project project, String pattern) async {
    httpClient.timeout = const Duration(minutes: 10);
    String projectName = project.name;
    final response = await get(
        "http://$uri:5000/lifecycle?project=$projectName&pattern=$pattern");
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      Map<String, dynamic> decode = response.body;
      Iterable<Future<PatternInstance>> result = decode.entries
          .map((e) async => PatternInstance.fromMap(e.key,
              e.value as List<dynamic>, await getAnnotations(project, e.key)))
          .toList();
      return await Future.wait(result);
    }
  }

  Future<List<Annotation>> getAnnotations(
      Project project, String patternInstance) async {
    String projectName = project.name;
    final response = await get(
        "http://$uri:5000/annotations?project=$projectName&pattern_instance=$patternInstance");
    if (response.status.hasError) {
      return [];
    }
    return (json.decode(response.body) as List<dynamic>)
        .map((e) => Annotation.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Commit>> getCommits(Project project) async {
    httpClient.timeout = const Duration(minutes: 10);
    String query = "?project=" + project.name;
    final response = await get("http://$uri:5000/documents" + query);
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return (json.decode(response.body) as List<dynamic>)
          .map((e) => Commit.fromMap(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<List<Project>> getProjects() async {
    httpClient.timeout = const Duration(minutes: 10);
    print("http://$uri:5000/projects");
    final response = await get("http://$uri:5000/projects");
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      List<Project> result = [];
      Map<String, dynamic> decode = response.body;
      result = decode.entries.map((e) => Project.fromMap(e.value)).toList();
      return result;
    }
  }

  Future<FileHistory> getFileHistory(
      Project project, DesignPattern pattern, String patternInstance) async {
    httpClient.timeout = const Duration(minutes: 10);
    String projectName = project.name;
    String patternName = pattern.parseString();
    final response = await http.get(Uri.parse(
        'http://$uri:5000/related_files?project=$projectName&pattern=$patternName&pattern_instance=$patternInstance'));
    if (response.statusCode != 200) {
      return Future.error(response.body);
    } else {
      Map<String, dynamic> a = json.decode(response.body);
      return FileHistory(a.map((key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map((commit, content) =>
              MapEntry(commit, ModifiedFile.fromMap(key, content))))));
    }
  }
}
