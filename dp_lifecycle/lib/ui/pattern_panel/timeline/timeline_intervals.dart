import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dp_lifecycle/struct/interval.dart' as g;
import 'dart:math' as math;

class TimelineInterval extends GetView<TimelineController> {
  final List<g.Interval> intervals;
  final List<g.Interval> annotations;
  final DesignPattern designPattern;
  final Map<String, Color> colourMap = {};
  final List<Color> availableColours = [];

  TimelineInterval(this.designPattern, this.intervals, this.annotations,
      {Key? key})
      : super(key: key) {
    colourMap['Pattern'] = designPattern.toColour();

    for (int i = 0; i < 4; i++) {
      availableColours.add(HSLColor.fromColor(designPattern.toColour())
          .withLightness(0.4 + 0.18 * i)
          .withSaturation(0.4 + 0.18 * i)
          .toColor());
    }
  }

  double interpolateScreenPos(double position, BuildContext context) {
    if (position < 0) return 0;
    if (position > 1) return 1;
    return (MediaQuery.of(context).size.width - 650) * position;
  }

  Color _getColor(g.Interval interval, int index) {
    if (colourMap.containsKey(interval.modificationCommit)) {
      return colourMap[interval.modificationCommit]!;
    }
    colourMap[interval.modificationCommit] = availableColours[
        index - (index ~/ availableColours.length) * availableColours.length];
    return colourMap[interval.modificationCommit]!;
  }

  List<Widget> _generateBreakIntervals(BuildContext context) {
    return annotations
        .map((e) => GetBuilder<TimelineController>(
            builder: ((c) => Positioned(
                left: interpolateScreenPos(
                        c.normalizedPosition(e.start), context) +
                    25,
                bottom: -5,
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    //height: 5,
                    //color: Colors.red,
                    child: Transform.rotate(
                      angle: math.pi / 2,
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.red,
                      ),
                    ),
                    width: (interpolateScreenPos(
                        controller.normalizedPosition(e.end) -
                            controller.normalizedPosition(e.start),
                        context)))))))
        .toList();
  }

  List<Widget> _generateIntervals(BuildContext context) {
    return intervals
        .asMap()
        .entries
        .map((e) => GetBuilder<TimelineController>(
            builder: ((c) => Positioned(
                left: interpolateScreenPos(
                        c.normalizedPosition(e.value.start), context) +
                    25,
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    height: 40,
                    color: _getColor(e.value, e.key),
                    width: (interpolateScreenPos(
                        controller.normalizedPosition(e.value.end) -
                            controller.normalizedPosition(e.value.start),
                        context)))))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width - 600,
        child: Stack(children: [
          ..._generateIntervals(context),
          ..._generateBreakIntervals(context)
        ]));
  }
}
