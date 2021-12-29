import 'dart:convert';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:get/get_connect.dart';

class LifecycleProvider extends GetConnect {
  Future<List<PatternInstance>> getIntervals(String pattern) async {
    httpClient.timeout = const Duration(minutes: 10);
    final response = await get('http://127.0.0.1:5000/lifecycle');
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      List<PatternInstance> result = [];
      Map<String, dynamic> decode = response.body;
      result = decode.entries
          .map((e) =>
              PatternInstance.fromMap(e.key, pattern, e.value as List<dynamic>))
          .toList();
      return result;
    }
  }
}
