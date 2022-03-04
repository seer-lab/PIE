import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dp_lifecycle/struct/interval.dart' as g;
import 'dart:math' as math;

class TimelineInterval extends GetView<TimelineController> {
  final List<g.Interval> intervals;
  final DesignPattern designPattern;
  Map<String, Color> colourMap = {};
  List<Color> availableColours = [];
  int colourIndex = 0;
  TimelineInterval(this.designPattern, this.intervals, {Key? key})
      : super(key: key) {
    colourMap['Pattern'] = designPattern.toColour();

    for (int i = 0; i < 5; i++) {
      availableColours.add(HSLColor.fromColor(designPattern.toColour())
          .withLightness(0.4 + 0.1 * i)
          .withSaturation(0.4 + 0.1 * i)
          .toColor());
    }
  }

  double interpolateScreenPos(double position, BuildContext context) {
    if (position < 0) return 0;
    if (position > 1) return 1;
    return (MediaQuery.of(context).size.width - 650) * position;
  }

  Color _getColor(g.Interval interval) {
    if (colourMap.containsKey(interval.modificationCommit)) {
      return colourMap[interval.modificationCommit]!;
    }
    colourMap[interval.modificationCommit] = availableColours[colourIndex];
    colourIndex++;
    if (colourIndex >= availableColours.length) {
      colourIndex = 0;
    }
    return colourMap[interval.modificationCommit]!;
  }

  List<Widget> _generateIntervals(BuildContext context) {
    return intervals
        .map((e) => GetBuilder<TimelineController>(
            builder: ((c) => Positioned(
                left: interpolateScreenPos(
                        c.normalizedPosition(e.start), context) +
                    25,
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    height: 40,
                    color: _getColor(e),
                    width: (interpolateScreenPos(
                        controller.normalizedPosition(e.end) -
                            controller.normalizedPosition(e.start),
                        context)))))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 600,
        child: Stack(
          children: []..addAll(_generateIntervals(context)),
        ));
  }
}
