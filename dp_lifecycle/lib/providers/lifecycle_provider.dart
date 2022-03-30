import 'dart:convert';
import 'package:dp_lifecycle/struct/commit.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:dp_lifecycle/struct/file_history.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/struct/project.dart';
import 'package:get/get_connect.dart';

class LifecycleProvider extends GetConnect {
  Future<List<PatternInstance>> getIntervals(
      Project project, String pattern) async {
    httpClient.timeout = const Duration(minutes: 10);
    String projectName = project.name;
    final response = await get(
        "http://127.0.0.1:5000/lifecycle?project=$projectName&pattern=$pattern");
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      List<PatternInstance> result = [];
      Map<String, dynamic> decode = response.body;
      result = decode.entries
          .map((e) => PatternInstance.fromMap(e.key, e.value as List<dynamic>))
          .toList();
      return result;
    }
  }

  Future<List<Commit>> getCommits(Project project) async {
    httpClient.timeout = const Duration(minutes: 10);
    String query = "?project=" + project.name;
    final response = await get('http://127.0.0.1:5000/documents' + query);
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
    final response = await get('http://127.0.0.1:5000/projects');
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
    final response = await get(
        'http://127.0.0.1:5000/related_files?project=$projectName&pattern=$pattern&pattern_instance=$patternInstance');
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      Map<String, dynamic> a = response.body as Map<String, dynamic>;
      return FileHistory(
          a.map((key, value) => MapEntry(key, value as Map<String, dynamic>)));
    }
  }
}
