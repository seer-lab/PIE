class ModifiedFile {
  final String name, content, language, previousCommit;
  final List<Diff> added, deleted;
  ModifiedFile(this.name, this.content, this.added, this.deleted,
      {this.language = 'java', this.previousCommit = ''});

  factory ModifiedFile.fromMap(String name, Map<String, dynamic> data) {
    Map<String, dynamic> diff = data['diff'] as Map<String, dynamic>;
    List<Diff> added = (diff['added'] as List<dynamic>)
        .map((e) => Diff.fromList(e as List<dynamic>))
        .toList();
    List<Diff> deleted = (diff['deleted'] as List<dynamic>)
        .map((e) => Diff.fromList(e as List<dynamic>))
        .toList();
    return ModifiedFile(name, data['content'], added, deleted,
        previousCommit: data['previous_commit']);
  }
}

class Diff {
  final int index;
  final String content;
  Diff({required this.index, required this.content});
  factory Diff.fromList(List<dynamic> values) {
    return Diff(index: values[0] as int, content: values[1] as String);
  }
}
