class Interval {
  final int start, end;
  final String instance, modificationCommit;
  final String? pinotData;
  final Map<String, dynamic> data;

  Interval(this.start, this.end, this.instance, this.modificationCommit,
      this.pinotData, this.data);

  factory Interval.fromMap(Map<String, dynamic> json) {
    print(json);
    return Interval(json['start'], json['end'], json['instance'],
        json['modification'], json['pinot_data'], json);
  }

  bool get isPattern => modificationCommit == 'Pattern';
  String get fileName => instance.split(' ')[0];
}
