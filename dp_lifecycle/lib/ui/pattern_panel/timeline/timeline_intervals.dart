import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dp_lifecycle/struct/interval.dart' as g;
import 'dart:math' as math;

class TimelineInterval extends GetView<TimelineController> {
  final List<g.Interval> intervals;
  Map<String, Color> colourMap = {'Pattern': Colors.blue};
  TimelineInterval(this.intervals, {Key? key}) : super(key: key);

  double interpolateScreenPos(double position, BuildContext context) {
    if (position < 0) return 0;
    if (position > 1) return 1;
    return (MediaQuery.of(context).size.width - 650) * position;
  }

  Color _getColor(g.Interval interval) {
    if (colourMap.containsKey(interval.modificationCommit)) {
      return colourMap[interval.modificationCommit]!;
    }
    colourMap[interval.modificationCommit] =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
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
                    height: 50,
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
