import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline_file_interval.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline_pattern_interval.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dp_lifecycle/struct/interval.dart' as g;

import 'package:get/instance_manager.dart';

enum IntervalType { pattern, file }

class TimelineInterval extends GetView<TimelineController> {
  final PatternInstance pattern;
  final String? filename;
  final IntervalType intervalType;
  final VoidCallback onSelect;
  final Color _color;

  TimelineInterval(this.pattern, this.intervalType,
      {Key? key, this.filename, VoidCallback? onSelect})
      : assert(intervalType == IntervalType.pattern || filename != null),
        onSelect = onSelect ?? (() {}),
        _color = HSLColor.fromColor(pattern.pattern.toColour())
            .withLightness(0.85)
            .withSaturation(0.75)
            .toColor(),
        super(key: key);

  double interpolateScreenPos(double position, BuildContext context) {
    if (position < 0) return 0;
    if (position > 1) return 1;
    return (MediaQuery.of(context).size.width - 650) * position;
  }

  double get height {
    switch (intervalType) {
      case IntervalType.pattern:
        return 50;
      case IntervalType.file:
        return 25;
    }
  }

  Widget _getIntervals() {
    switch (intervalType) {
      case IntervalType.pattern:
        return TimelinePatternInterval(
            intervals: pattern.getPatternInterval(),
            breaks: pattern.getPatternBreaks(),
            colour: pattern.pattern.toColour(),
            onSelect: onSelect,
            height: height);
      case IntervalType.file:
        return TimelineFileInterval(
            intervals: pattern.getFileInterval(filename!),
            breaks: pattern.getPatternBreaks(filename: filename!),
            colour: _color,
            onSelectBody: onSelect,
            height: height);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UIController uiController = Get.find<UIController>();
    return SizedBox(
        height: height,
        width: uiController.getTimelineWidth(context),
        child: _getIntervals());
  }
}
