class Interval {
  final int start, end;
  final String instance, modificationCommit;

  Interval(this.start, this.end, this.instance, this.modificationCommit);

  factory Interval.fromMap(Map<String, dynamic> json) {
    return Interval(
        json['start'], json['end'], json['instance'], json['modification']);
  }
}
