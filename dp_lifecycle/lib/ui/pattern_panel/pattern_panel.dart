import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/panel_header.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_card.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_timeline.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';

class PatternPanel extends GetView<LifecycleController> {
  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(children: [
                Container(
                  height: 100,
                  child: Row(children: [PanelHeader(), Timeline()]),
                ),
                Container(
                    height: 600,
                    child: ListView.builder(
                      itemCount: state!.length,
                      itemBuilder: (context, index) => Row(children: [
                        PatternCard(state[index]),
                        PatternTimeline(state[index])
                      ]),
                    ))
              ]),
              height: 700,
            ),
        onEmpty: Container(),
        onLoading: Container(
            height: 700,
            child: const Center(
              child: CircularProgressIndicator(),
            )));
  }
}
