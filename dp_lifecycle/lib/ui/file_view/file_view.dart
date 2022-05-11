import 'package:code_editor/code_editor.dart';
import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class FileView extends StatefulWidget {
  const FileView({Key? key}) : super(key: key);

  @override
  _FileView createState() => _FileView();
}

class _FileView extends State<FileView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimelineController>(
        builder: (c) => c.commits.isEmpty
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                    child: CodeEditor(
                  edit: false,
                  model: EditorModel(
                      files: c.getFiles(),
                      styleOptions: EditorModelStyleOptions(
                          heightOfContainer:
                              // Need to subtract 60 to account for padding + file bar
                              MediaQuery.of(context).size.height / 2 - 60)),
                ))));
  }
}
