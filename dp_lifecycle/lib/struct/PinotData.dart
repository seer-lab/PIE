import 'package:dp_lifecycle/struct/design_pattern.dart';

class PinotData {
  final Map<String, String> pinotData;
  const PinotData(this.pinotData);

  factory PinotData.fromMap(Map<String, dynamic> json) {
    Map<String, String> data = {};
    json.forEach((key, value) {
      (value as List<dynamic>).forEach((e) {
        if (e.containsKey('details')) {
          String name = (e['path'].cast<String>() as List<String>)
              .map(
                (e) => e.split('/').last.replaceAll('.java', ''),
              )
              .toList()
              .join('-');
          data[name] = e['details'];
        }
      });
    });
    return PinotData(data);
  }
}
