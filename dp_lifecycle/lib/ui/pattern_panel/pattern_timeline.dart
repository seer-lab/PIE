import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline_intervals.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';

class PatternTimeline extends GetView<TimelineController> {
  final PatternInstance pattern;
  final bool isOpen;
  const PatternTimeline(this.pattern, this.isOpen, {Key? key})
      : super(key: key);

  List<Widget> getFileTimelines() {
    List<Widget> timelines = [];
    if (!isOpen) return timelines;
    pattern.files.forEach((element) {
      timelines.add(
          TimelineInterval(pattern.pattern, pattern.getFileInterval(element)));
    });
    return timelines;
  }

  List<BoxShadow>? _shadow() {
    if (controller.selectedPattern != null) {
      if (controller.selectedPattern!.value == pattern) {
        return [
          BoxShadow(color: Colors.white, spreadRadius: 10, blurRadius: 20)
        ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50 + 50.0 * (isOpen ? pattern.files.length : 0),
      width: MediaQuery.of(context).size.width - 600,
      child: Center(
          child: Column(
              children: [
        TimelineInterval(pattern.pattern, pattern.getPatternInterval())
      ]..addAll(getFileTimelines()))),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromARGB(255, 27, 27, 27),
        // boxShadow: _shadow(),
      ),
    );
  }
}
