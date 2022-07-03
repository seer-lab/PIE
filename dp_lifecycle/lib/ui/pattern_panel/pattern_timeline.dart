import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline_intervals.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class PatternTimeline extends GetView<TimelineController> {
  final PatternInstance pattern;
  final bool isOpen, isSelected;
  final VoidCallback onSelect;
  final fileHeight = 30.0;
  const PatternTimeline(
      this.pattern, this.isOpen, this.onSelect, this.isSelected,
      {Key? key})
      : super(key: key);

  void moveCursorTo(int commitNumber) {
    controller.updatePreviewMarker(commitNumber);
  }

  List<Widget> getFileTimelines() {
    List<Widget> timelines = [];
    if (!isOpen) return timelines;
    for (String element in pattern.files) {
      timelines.add(TimelineInterval(
        pattern,
        IntervalType.file,
        onSelect: onSelect,
        filename: element,
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
        TimelineInterval(
          pattern,
          IntervalType.pattern,
          onSelect: onSelect,
        ),
        ...getFileTimelines()
      ])),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 27, 27, 27),
          boxShadow: (isSelected)
              ? ([
                  const BoxShadow(
                      blurRadius: 8, spreadRadius: 2, color: Colors.white)
                ])
              : null
          // boxShadow: _shadow(),
          ),
    );
  }
}
