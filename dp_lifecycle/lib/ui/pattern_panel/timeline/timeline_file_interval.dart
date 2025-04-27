import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/struct/broken_annotation.dart';
import 'package:dp_lifecycle/struct/stale_annotation.dart';
import 'package:flutter/material.dart';
import 'package:dp_lifecycle/struct/interval.dart' as g;
import 'package:get/get_state_manager/get_state_manager.dart';

class TimelineFileInterval extends StatelessWidget {
  final List<g.Interval> intervals;
  final List<StaleAnnotation> staleIntervals;
  final List<BrokenAnnotation> breaks;
  late final Map<int, BrokenAnnotation> breakMapping;
  final Color colour;
  final double height;
  final VoidCallback onSelectBody, onSelectDivider;

  TimelineFileInterval({
    Key? key,
    required this.intervals,
    required this.breaks,
    required this.colour,
    required this.height,
    List<StaleAnnotation>? staleIntervals,
    VoidCallback? onSelectDivider,
    VoidCallback? onSelectBody,
  })  : onSelectBody = onSelectBody ?? (() {}),
        onSelectDivider = onSelectDivider ?? (() {}),
        staleIntervals = staleIntervals ?? [],
        breakMapping = {}
          ..addEntries(breaks.map((e) => MapEntry(e.commit, e)).toList()),
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

  Widget _createIntervalDivider(double leftPosition, int commit) {
    Color _colour = breakMapping.containsKey(commit)
        ? Colors.red
        : HSLColor.fromColor(colour).withLightness(0.4).toColor();

    return Positioned(
        left: leftPosition,
        child: InkWell(
            onTap: () => onSelectDivider(),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                height: height * 4 / 5,
                color: _colour,
                width: 2)));
  }

  Widget _createStaleAnnotation(double leftPosition, double width) {
    return Positioned(
        left: leftPosition,
        bottom: 0,
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          height: height * 1 / 5,
          color: Colors.red,
          width: width,
        ));
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
                builder: ((c) => _createIntervalDivider(
                    interpolateScreenPos(
                            c.normalizedPosition(e.value.start), context) +
                        25,
                    e.value.start))))
            .toList();
  }

  List<Widget> _generateStaleAnnotations(BuildContext context) {
    return staleIntervals
        .map((e) => GetBuilder<TimelineController>(
            builder: (c) => _createStaleAnnotation(
                interpolateScreenPos(c.normalizedPosition(e.start), context) +
                    25,
                (interpolateScreenPos(
                    c.normalizedPosition(e.end) - c.normalizedPosition(e.start),
                    context)))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._generateIntervals(context),
        ..._generateStaleAnnotations(context)
      ],
    );
  }
}
