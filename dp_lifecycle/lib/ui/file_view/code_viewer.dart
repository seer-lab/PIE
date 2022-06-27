import 'package:code_editor/code_editor.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/struct/file_view_style.dart';
import 'package:dp_lifecycle/struct/modified_file.dart';
import 'package:dp_lifecycle/ui/file_view/combined_code.dart';
import 'package:dp_lifecycle/ui/file_view/seperated_code.dart';
import 'package:dp_lifecycle/ui/file_view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class CodeViewer extends StatelessWidget {
  final List<ModifiedFile> files;
  final FileViewStyle style;
  CodeViewer(this.files, this.style, {Key? key}) : super(key: key);
  final UIController uiController = Get.find<UIController>();

  Widget _codeViewDelegate(ModifiedFile file) {
    switch (style) {
      case (FileViewStyle.combined):
        return CombinedCode(file);
      case (FileViewStyle.seperated):
        return SeperatedCode(file);
      case (FileViewStyle.noChanges):
        return CombinedCode(file);
      default:
        return CombinedCode(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: files.length + 1,
        child: Column(
          children: [
            TabBar(
                padding: EdgeInsets.zero,
                tabs: files
                    .map((e) => Tab(
                          text: e.name,
                        ))
                    .toList()
                  ..add(const Tab(
                    child: Icon(Icons.settings),
                  ))),
            Expanded(
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children:
                        files.map<Widget>((e) => _codeViewDelegate(e)).toList()
                          ..add(SettingsPage())))
          ],
        ));
  }
}
