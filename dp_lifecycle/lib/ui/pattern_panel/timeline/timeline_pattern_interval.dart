import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/struct/broken_annotation.dart';
import 'package:dp_lifecycle/struct/interval.dart' as g;
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'dart:math' as math;

class TimelinePatternInterval extends StatelessWidget {
  final List<g.Interval> intervals;
  final List<BrokenAnnotation> breaks;
  final Color colour;
  final VoidCallback onSelect;
  final double height;

  TimelinePatternInterval(
      {Key? key,
      required this.intervals,
      required this.breaks,
      required this.colour,
      required this.height,
      VoidCallback? onSelect})
      : onSelect = onSelect ?? (() {}),
        super(key: key);

  double interpolateScreenPos(double position, BuildContext context) {
    if (position < 0) return 0;
    if (position > 1) return 1;
    return (MediaQuery.of(context).size.width - 650) * position;
  }

  List<Widget> _generateBreakIntervals(BuildContext context) {
    return breaks
        .map((e) => GetBuilder<TimelineController>(
            builder: ((c) => Positioned(
                left: interpolateScreenPos(
                        c.normalizedPosition(e.commit), context) +
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
                    width: 3)))))
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
                child: InkWell(
                    onTap: () => onSelect(),
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: height * 4 / 5,
                        color: colour,
                        width: (interpolateScreenPos(
                            c.normalizedPosition(e.value.end) -
                                c.normalizedPosition(e.value.start),
                            context))))))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._generateIntervals(context),
        ..._generateBreakIntervals(context)
      ],
    );
  }
}
