import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/ui/filters/design_pattern_selector.dart';
import 'package:dp_lifecycle/ui/filters/file_view_style_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final UIController uiController = Get.find<UIController>();

  final Map<String, Widget> layout = {
    'Design Patterns': const DesignPatternSelector(),
    'File Viewer Style': const FileViewStyleSelector(),
  };

  Widget sectionWrapper(String name, Widget child) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          child,
          const Divider(
            thickness: 4,
          )
        ],
      ),
      const SizedBox(
        height: 4,
      ),
      const Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
      width: uiController.getCodeEditorWidth(context),
      child: ListView(children: [
        ...layout.entries
            .map<Widget>((e) => sectionWrapper(e.key, e.value))
            .toList()
      ]),
    );
  }
}
