import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/struct/modified_file.dart';
import 'package:dp_lifecycle/ui/file_view/code.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class SeperatedCode extends StatelessWidget {
  final ModifiedFile file;
  SeperatedCode(this.file, {Key? key}) : super(key: key);

  final UIController uiController = Get.find<UIController>();
  final TimelineController timelineController = Get.find<TimelineController>();

  ModifiedFile _getPreviousFile() {
    if (file.previousCommit.isEmpty) {
      return ModifiedFile(file.name, 'No Previous Commit for this File');
    }
    ModifiedFile previousFile =
        timelineController.getFileAtCommit(file.name, file.previousCommit);
    return ModifiedFile(previousFile.name, previousFile.content,
        deleted: file.deleted);
  }

  @override
  Widget build(BuildContext context) {
    //Buffer buffer = Buffer(file, _getPreviousFile());
    return SingleChildScrollView(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: uiController.getCodeEditorWidth(context) / 2,
            child: Code(
              _getPreviousFile(),
              showDeletions: true,
              width: uiController.getCodeEditorWidth(context) / 2,
            )),
        SizedBox(
            width: uiController.getCodeEditorWidth(context) / 2,
            child: Code(
              file,
              showAdditions: true,
              width: uiController.getCodeEditorWidth(context) / 2,
            )),
      ],
    ));
  }
}
