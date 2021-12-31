import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dp_lifecycle/struct/interval.dart' as g;

class TimelineInterval extends GetView<TimelineController> {
  final List<g.Interval> intervals;
  const TimelineInterval(this.intervals, {Key? key}) : super(key: key);

  double interpolateScreenPos(double position, BuildContext context) {
    if (0 < position && position < 1)
      return (MediaQuery.of(context).size.width - 650) * position;
    return 0;
  }

  List<Widget> _generateIntervals(BuildContext context) {
    return intervals
        .map((e) => GetBuilder<TimelineController>(
            builder: ((c) => Positioned(
                left: interpolateScreenPos(
                        c.normalizedPosition(e.start), context) +
                    25,
                child: Container(
                    height: 20,
                    color: Colors.blue,
                    width: (interpolateScreenPos(
                        controller.normalizedPosition(e.end) -
                            controller.normalizedPosition(e.start),
                        context)))))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        width: MediaQuery.of(context).size.width - 600,
        child: Stack(
          children: []..addAll(_generateIntervals(context)),
        ));
  }
}
