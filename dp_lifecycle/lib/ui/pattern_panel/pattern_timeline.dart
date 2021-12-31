import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline_intervals.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';

class PatternTimeline extends GetView<TimelineController> {
  final PatternInstance pattern;
  const PatternTimeline(this.pattern, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width - 600,
      child: Center(child: TimelineInterval(pattern.getPatternInterval())),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 216, 216, 216),
      ),
    );
  }
}
