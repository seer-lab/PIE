import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/ui/pattern_panel/panel_header.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_row.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class PatternPanel extends GetView<LifecycleController> {
  const PatternPanel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UIController uiController = Get.find<UIController>();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          children: [
            Positioned(
                top: uiController.timelineControllerHeight,
                child: controller.obx(
                    (state) => SizedBox(
                        height: uiController.getCentre(context) -
                            uiController.timelineControllerHeight * 2,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            itemCount: state!.length,
                            itemBuilder: (context, index) =>
                                PatternRow(state[index]))),
                    onLoading: SizedBox(
                      height: uiController.getCentre(context),
                      child: const Center(child: CircularProgressIndicator()),
                    ))),
            Positioned(
              top: 0,
              child: SizedBox(
                height: uiController.timelineControllerHeight,
                child: Row(children: const [PanelHeader(), Timeline()]),
              ),
            ),
          ],
        ),
        height: uiController.getCodeEditorHeight(context));
  }
}
