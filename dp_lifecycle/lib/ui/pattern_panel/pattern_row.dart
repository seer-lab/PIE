import 'package:flutter/material.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_card.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_timeline.dart';

class PatternRow extends StatefulWidget {
  final PatternInstance pattern;
  const PatternRow(this.pattern, {Key? key}) : super(key: key);
  _PatternRow createState() => _PatternRow();
}

class _PatternRow extends State<PatternRow> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Listener(
        onPointerUp: (e) => setState(() => isOpen = !isOpen),
        child: PatternCard(widget.pattern, isOpen),
      ),
      PatternTimeline(widget.pattern, isOpen)
    ]);
  }
}
