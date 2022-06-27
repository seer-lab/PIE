import 'package:dp_lifecycle/struct/modified_file.dart';

class FileHistory {
  final Map<String, Map<String, ModifiedFile>> data;
  FileHistory(this.data);

  ModifiedFile? getFile(String commit, String filename) {
    if (data.containsKey(filename) && data[filename]!.containsKey(commit)) {
      return data[filename]![commit];
    }
    return null;
  }

  ModifiedFile? getFileDiff(String commit, String filename) {
    ModifiedFile? file = getFile(commit, filename);
    if (file == null) {
      return null;
    }
    return ModifiedFile(file.name, applyDiff(file), file.added, file.deleted,
        previousCommit: file.previousCommit);
  }

  String applyDiff(ModifiedFile file) {
    List<String> content = file.content.split('\n');

    file.added.forEach((diff) {
      content[diff.index - 1] = '+ ' + content[diff.index - 1];
    });

    for (int i = 0; i < content.length; i++) {
      if (content[i].isNotEmpty && content[i][0] != '+') {
        content[i] = '  ' + content[i];
      }
    }

    file.deleted.forEach((diff) {
      content.insert(diff.index - 1, '- ' + diff.content);
    });

    return content.join('\n');
  }
}
