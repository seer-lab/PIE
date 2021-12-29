import 'package:flutter/material.dart';

class DPChip extends StatelessWidget {
  final String designPattern;
  final Map<String, MaterialColor> colourMapping = {
    "Flyweight": Colors.amber,
    "Strategy": Colors.blue,
    "Bridge": Colors.green
  };

  DPChip(this.designPattern, {Key? key}) : super(key: key);

  Color _getColour() {
    if (colourMapping.containsKey(designPattern)) {
      return Color(colourMapping[designPattern]!.value);
    }
    return Color(Colors.grey.value);
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
        label: Text(
          designPattern,
          style: TextStyle(
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, offset: Offset(0, -1.0))]),
        ),
        backgroundColor: _getColour());
  }
}
