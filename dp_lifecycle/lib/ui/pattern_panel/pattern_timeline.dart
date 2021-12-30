import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';

class PatternTimeline extends GetView<TimelineController> {
  final PatternInstance pattern;
  const PatternTimeline(this.pattern, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 600,
      child: const Center(child: LinearProgressIndicator()),
    );
  }
}
