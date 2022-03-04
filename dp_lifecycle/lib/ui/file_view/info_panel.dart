import 'package:code_editor/code_editor.dart';
import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class InfoPanel extends StatefulWidget {
  _InfoPanel createState() => _InfoPanel();
}

class _InfoPanel extends State<InfoPanel> {
  Widget _heading(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          text,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          color: Colors.white,
          height: 2,
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimelineController>(
        builder: (c) => Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width * 0.2,
            color: const Color.fromARGB(255, 46, 46, 46),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ListView(
              children: [
                const Text(
                  "Commit Data",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                _heading('General'),
                Text(c.getCommit().hash),
                const SizedBox(height: 10),
                Text(c.getCommit().message),
                const SizedBox(height: 10),
                Text("Author: " + c.getCommit().author),
                _heading('Pinot Data'),
                Text(
                  c.getPinotInfo(),
                  style: const TextStyle(fontSize: 18),
                )
              ],
            )));
  }
}
