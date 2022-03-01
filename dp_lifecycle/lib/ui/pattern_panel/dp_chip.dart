import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:flutter/material.dart';

class DPChip extends StatelessWidget {
  final DesignPattern designPattern;
  final bool isSelected;
  final Map<DesignPattern, MaterialColor> colourMapping = {
    DesignPattern.flyweight: Colors.amber,
    DesignPattern.strategy: Colors.blue,
    DesignPattern.bridge: Colors.green,
    DesignPattern.composite: Colors.red,
    DesignPattern.decorator: Colors.indigo,
    DesignPattern.mediator: Colors.purple,
    DesignPattern.proxy: Colors.orange,
    DesignPattern.na: Colors.grey
  };

  DPChip(this.designPattern, {Key? key, this.isSelected = false})
      : super(key: key);

  Color _getColour() {
    if (colourMapping.containsKey(designPattern)) {
      return Color(colourMapping[designPattern]!.value);
    }
    return Color(Colors.grey.value);
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
        avatar:
            isSelected ? const CircleAvatar(child: Icon(Icons.check)) : null,
        label: Text(
          designPattern.parseString(),
          style: const TextStyle(
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, offset: Offset(0, -1.0))]),
        ),
        backgroundColor: _getColour());
  }
}
