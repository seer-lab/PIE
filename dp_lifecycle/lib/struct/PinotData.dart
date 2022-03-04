import 'package:dp_lifecycle/struct/design_pattern.dart';

class PinotData {
  final Map<String, String> pinotData;
  const PinotData(this.pinotData);

  factory PinotData.fromMap(Map<String, dynamic> json) {
    Map<String, String> data = {};
    json.forEach((key, value) {
      (value as List<dynamic>).forEach((e) {
        if (e.containsKey('details')) {
          List<String> names = (e['path'].cast<String>() as List<String>);
          names.sort();
          String name = names
              .map(
                (e) => e.split('/').last.replaceAll('.java', ''),
              )
              .toList()
              .join('-');
          name += "-" + key.substring(0, 2);

          data[name] = e['details'];
        }
      });
    });
    return PinotData(data);
  }
}
