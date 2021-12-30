import 'package:flutter/material.dart';

class PanelHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 550,
        child: const Center(
          child: Text(
            'Pattern Instances',
            style: TextStyle(fontSize: 20),
          ),
        ));
  }
}
