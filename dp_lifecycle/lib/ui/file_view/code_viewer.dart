import 'package:code_editor/code_editor.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/ui/file_view/code.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class CodeViewer extends StatelessWidget {
  final List<FileEditor> files;
  CodeViewer(this.files, {Key? key}) : super(key: key);
  final UIController uiController = Get.find<UIController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: files.length,
        child: Column(
          children: [
            TabBar(
                padding: EdgeInsets.zero,
                tabs: files
                    .map((e) => Tab(
                          text: e.name,
                        ))
                    .toList()),
            SizedBox(
                height: uiController.getCodeEditorHeight(context),
                width: uiController.getCodeEditorWidth(context),
                child: Expanded(
                    child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: files.map((e) => Code(e)).toList())))
          ],
        ));
  }
}
