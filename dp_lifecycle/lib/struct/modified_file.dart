class ModifiedFile {
  final String name, content, language, previousCommit;
  final List<Diff> added, deleted;
  ModifiedFile(this.name, this.content,
      {List<Diff>? added,
      List<Diff>? deleted,
      this.language = 'java',
      this.previousCommit = ''})
      : added = added ?? [],
        deleted = deleted ?? [];

  factory ModifiedFile.fromMap(String name, Map<String, dynamic> data) {
    Map<String, dynamic> diff = data['diff'] as Map<String, dynamic>;
    List<Diff> added = (diff['added'] as List<dynamic>)
        .map((e) => Diff.fromList(e as List<dynamic>))
        .toList();
    List<Diff> deleted = (diff['deleted'] as List<dynamic>)
        .map((e) => Diff.fromList(e as List<dynamic>))
        .toList();
    return ModifiedFile(name, data['content'],
        added: added,
        deleted: deleted,
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

class Buffer {
  final ModifiedFile current, previous;
  Buffer(this.current, this.previous);

  ModifiedFile get bufferedCurrent {
    List<String> output = current.content.split('\n');

    for (int i = 0; i < previous.deleted.length; i++) {
      List<Diff> modifications = current.added
          .where((element) => element.index == previous.deleted[i].index)
          .toList();
      if (modifications.isNotEmpty) {
        modifications.forEach((e) {
          int difference = previous.deleted[i].content.split('\n').length -
              e.content.split('\n').length -
              1;
          if (difference > 0) {
            output.insert(e.index + e.content.split('\n').length,
                '/////////////////////////////////// \n' * difference);
          }
        });
      } else {
        int difference = previous.deleted[i].content.split('\n').length;
        output.insert(previous.deleted[i].index - 1,
            '/////////////////////////////////// \n' * difference);
      }
    }
    return ModifiedFile(current.name, output.join('\n'), added: current.added);
  }

  ModifiedFile get bufferedPrevious {
    List<String> output = previous.content.split('\n');

    for (int i = 0; i < current.added.length; i++) {
      List<Diff> modifications = previous.deleted
          .where((element) => element.index == current.added[i].index)
          .toList();
      if (modifications.isNotEmpty) {
        modifications.forEach((e) {
          int difference = current.added[i].content.split('\n').length -
              e.content.split('\n').length;
          if (difference > 0) {
            output.insert(e.index + e.content.split('\n').length - 1,
                '/////////////////////////////////// \n' * difference);
          }
        });
      } else {
        int difference = current.added[i].content.split('\n').length;
        output.insert(previous.deleted[i].index - 1,
            '/////////////////////////////////// \n' * difference);
      }
    }
    return ModifiedFile(previous.name, output.join('\n'),
        deleted: previous.deleted);
  }
}
