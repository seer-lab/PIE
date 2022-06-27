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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
            width: uiController.getCodeEditorWidth(context),
            child: Code(file)));
  }
}
