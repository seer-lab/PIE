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

  Widget _dataEntry(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: SelectableText(text))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimelineController>(
        builder: (c) => c.commits.isEmpty
            ? Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width * 0.2,
                child: const Center(child: CircularProgressIndicator()),
                color: Theme.of(context).backgroundColor,
              )
            : Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width * 0.2,
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: ListView(
                  children: [
                    const Text(
                      "Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    _heading('Commit Data'),
                    _dataEntry(Icons.location_pin, c.getCommit().hash),
                    const SizedBox(height: 10),
                    _dataEntry(Icons.message, c.getCommit().message),
                    const SizedBox(height: 10),
                    _dataEntry(Icons.person, c.getCommit().author),
                    const SizedBox(height: 10),
                    _dataEntry(Icons.calendar_today, c.getCommit().date),
                    _heading('Pinot Data'),
                    SelectableText(
                      c.getPinotInfo(),
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                )));
  }
}
