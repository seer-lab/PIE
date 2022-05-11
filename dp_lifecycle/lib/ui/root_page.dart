import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/ui/file_view/file_view.dart';
import 'package:dp_lifecycle/ui/file_view/info_panel.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_panel.dart';
import 'package:dp_lifecycle/ui/project_select/project_selection.dart';
import 'package:dp_lifecycle/ui/tutorial_panel/tutorial_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UIController uiController = Get.find<UIController>();
    return GetBuilder<TimelineController>(
        builder: (c) => Scaffold(
            appBar: AppBar(
              title: Text('Pattern Instance Explorer: ' +
                  c.selectedProject.value.name.toUpperCase()),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      icon: const Icon(Icons.info)),
                )
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  child: Row(children: const [FileView(), InfoPanel()]),
                  height: uiController.getCentre(context),
                ),
                const PatternPanel()
              ],
            ),
            drawer: const Drawer(
              child: ProjectSelection(),
              elevation: 15.0,
            ),
            endDrawer: const Drawer(
              child: TutorialPanel(),
              elevation: 15.0,
            )));
  }
}
