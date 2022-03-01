import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:flutter/material.dart';

class DPChip extends StatelessWidget {
  final DesignPattern designPattern;
  final bool isSelected;

  DPChip(this.designPattern, {Key? key, this.isSelected = false})
      : super(key: key);

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
        backgroundColor: designPattern.toColour());
  }
}
