import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_card.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';

class PatternPanel extends GetView<LifecycleController> {
  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                itemCount: state!.length,
                itemBuilder: (context, index) => PatternCard(state[index]),
              ),
              width: 550,
              height: 700,
            ),
        onEmpty: Container(),
        onLoading: Container(
            width: 500,
            height: 700,
            child: const Center(
              child: CircularProgressIndicator(),
            )));
  }
}
