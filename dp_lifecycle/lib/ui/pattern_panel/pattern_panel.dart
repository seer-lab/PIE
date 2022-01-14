import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/ui/pattern_panel/panel_header.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_row.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';

class PatternPanel extends GetView<LifecycleController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(children: [
        Container(
          height: 100,
          child: Row(children: [PanelHeader(), Timeline()]),
        ),
        controller.obx(
            (state) => Container(
                height: 600,
                child: ListView.builder(
                    itemCount: state!.length,
                    itemBuilder: (context, index) => PatternRow(state[index]))),
            onLoading: Container(
              height: 600,
              child: const Center(child: CircularProgressIndicator()),
            ))
      ]),
      height: 700,
    );
  }
}
