class FileHistory {
  final Map<String, Map<String, dynamic>> data;
  FileHistory(this.data);

  String? getFile(String commit, String filename) {
    if (data.containsKey(commit) && data[commit]!.containsKey(filename)) {
      return data[commit]![filename];
    }
    return null;
  }
}
