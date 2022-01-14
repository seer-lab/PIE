import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/dp_chip.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PatternCard extends StatelessWidget {
  final PatternInstance pattern;
  final bool isOpen;
  const PatternCard(this.pattern, this.isOpen, {Key? key}) : super(key: key);

  List<Widget> getRelatedFiles() {
    List<Widget> fileTitles = [];
    if (!isOpen) {
      return fileTitles;
    }
    pattern.files.forEach((element) {
      fileTitles.add(Container(
        height: 50,
        padding: const EdgeInsets.all(10.0),
        child: Text(
          element,
          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
      ));
    });
    return fileTitles;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 550,
        height: 60 + 50.0 * (isOpen ? pattern.files.length : 0),
        child: Card(
            child: Column(
          children: <Widget>[
            Container(
                height: 50,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pattern.name.length > 35
                          ? pattern.name.substring(0, 33) + '..'
                          : pattern.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.file_copy, color: Colors.grey),
                        Text(pattern.files.length.toString()),
                        const SizedBox(
                          width: 5,
                        ),
                        DPChip(pattern.pattern),
                        Transform.rotate(
                          angle: isOpen ? -math.pi / 2 : 0,
                          child: const Icon(Icons.chevron_left),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                )),
          ]..addAll(getRelatedFiles()),
        )));
  }
}
