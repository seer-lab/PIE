class FileHistory {
  final Map<String, Map<String, dynamic>> data;
  FileHistory(this.data);

  String? getFile(String commit, String filename) {
    if (data.containsKey(filename) && data[filename]!.containsKey(commit)) {
      return data[filename]![commit];
    }
    return null;
  }
}
