import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:dp_lifecycle/struct/interval.dart' as g;
import 'package:get/get_state_manager/get_state_manager.dart';

class TimelineFileInterval extends StatelessWidget {
  final List<g.Interval> intervals;
  final List<g.Interval> annotations;
  final Color colour;
  final double height;
  final VoidCallback onSelectBody, onSelectDivider;

  TimelineFileInterval({
    Key? key,
    required this.intervals,
    required this.annotations,
    required this.colour,
    required this.height,
    VoidCallback? onSelectDivider,
    VoidCallback? onSelectBody,
  })  : onSelectBody = onSelectBody ?? (() {}),
        onSelectDivider = onSelectDivider ?? (() {}),
        super(key: key);

  double interpolateScreenPos(double position, BuildContext context) {
    if (position < 0) return 0;
    if (position > 1) return 1;
    return (MediaQuery.of(context).size.width - 650) * position;
  }

  Widget _createIntervalBody(double width, double leftPosition) {
    return Positioned(
        left: leftPosition,
        child: InkWell(
            onTap: () => onSelectBody(),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                height: height * 4 / 5,
                color: colour,
                width: width)));
  }

  Widget _createIntervalDivider(double leftPosition) {
    return Positioned(
        left: leftPosition,
        child: InkWell(
            onTap: () => onSelectDivider(),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                height: height * 4 / 5,
                color: HSLColor.fromColor(colour).withLightness(0.2).toColor(),
                width: 2)));
  }

  List<Widget> _generateIntervals(BuildContext context) {
    return intervals
            .asMap()
            .entries
            .map((e) => GetBuilder<TimelineController>(
                builder: ((c) => _createIntervalBody(
                    (interpolateScreenPos(
                        c.normalizedPosition(e.value.end) -
                            c.normalizedPosition(e.value.start),
                        context)),
                    interpolateScreenPos(
                            c.normalizedPosition(e.value.start), context) +
                        25))))
            .toList() +
        intervals
            .asMap()
            .entries
            .map((e) => GetBuilder<TimelineController>(
                builder: ((c) => _createIntervalDivider(interpolateScreenPos(
                        c.normalizedPosition(e.value.start), context) +
                    25))))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [..._generateIntervals(context)],
    );
  }
}
