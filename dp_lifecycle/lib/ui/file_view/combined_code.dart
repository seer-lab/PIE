import 'package:code_editor/code_editor.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/struct/modified_file.dart';
import 'package:dp_lifecycle/ui/file_view/code.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class CombinedCode extends StatelessWidget {
  final ModifiedFile file;
  CombinedCode(this.file, {Key? key}) : super(key: key);
  final UIController uiController = Get.find<UIController>();

  ModifiedFile _combineDiffs() {
    List<String> output = file.content.split('\n');
    List<Diff> shiftedAdded = [];

    for (int i = 0; i < file.added.length; i++) {
      output[file.added[i].index - 1] = '+ ' + output[file.added[i].index - 1];
    }
    for (int i = 0; i < file.deleted.length; i++) {
      output.insertAll(
          file.deleted[i].index - 1, file.deleted[i].content.split('\n'));
    }

    for (int i = 0; i < output.length; i++) {
      if (output[i].isNotEmpty && output[i][0] == '+') {
        output[i] = output[i].substring(1);
        shiftedAdded.add(Diff(index: i + 1, content: output[i]));
      }
    }
    return ModifiedFile(file.name, output.join('\n'),
        added: shiftedAdded, deleted: file.deleted);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
            width: uiController.getCodeEditorWidth(context),
            child: Code(
              _combineDiffs(),
              showAdditions: true,
              showDeletions: true,
            )));
  }
}
