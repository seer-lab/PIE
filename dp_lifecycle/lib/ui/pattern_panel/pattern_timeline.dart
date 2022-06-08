import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline_intervals.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class PatternTimeline extends GetView<TimelineController> {
  final PatternInstance pattern;
  final bool isOpen;
  final fileHeight = 30.0;
  const PatternTimeline(this.pattern, this.isOpen, {Key? key})
      : super(key: key);

  List<Widget> getFileTimelines() {
    List<Widget> timelines = [];
    if (!isOpen) return timelines;
    for (String element in pattern.files) {
      timelines.add(TimelineInterval(
        pattern.pattern,
        pattern.getFileInterval(element),
        pattern.getPatternBreaks(filename: element),
        height: 25,
      ));
    }
    return timelines;
  }

  @override
  Widget build(BuildContext context) {
    final UIController uiController = Get.find<UIController>();
    return Container(
      height: 50 + fileHeight * (isOpen ? pattern.files.length : 0),
      width: uiController.getTimelineWidth(context),
      child: Center(
          child: Column(children: [
        TimelineInterval(pattern.pattern, pattern.getPatternInterval(),
            pattern.getPatternBreaks()),
        ...getFileTimelines()
      ])),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 27, 27, 27),
        // boxShadow: _shadow(),
      ),
    );
  }
}
