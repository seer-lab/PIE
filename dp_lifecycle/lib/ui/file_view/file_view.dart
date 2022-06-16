import 'package:code_editor/code_editor.dart';
import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/ui/file_view/code_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class FileView extends StatefulWidget {
  const FileView({Key? key}) : super(key: key);

  @override
  _FileView createState() => _FileView();
}

class _FileView extends State<FileView> {
  @override
  Widget build(BuildContext context) {
    final UIController uiController = Get.find<UIController>();
    return GetBuilder<TimelineController>(
        builder: (c) => c.commits.isEmpty
            ? SizedBox(
                width: uiController.getCodeEditorWidth(context),
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
            : SizedBox(
                width: uiController.getCodeEditorWidth(context),
                child: CodeViewer(c.getFiles())));
  }
}
