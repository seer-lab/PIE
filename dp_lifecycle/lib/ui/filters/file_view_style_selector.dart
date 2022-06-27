import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/struct/file_view_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class FileViewStyleSelector extends StatelessWidget {
  const FileViewStyleSelector({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GetBuilder<TimelineController>(
          builder: ((c) => Column(
                children: [
                  RadioListTile<FileViewStyle>(
                      value: FileViewStyle.combined,
                      title: const Text('Combined Modifications'),
                      groupValue: c.fileViewStyle.value,
                      onChanged: (FileViewStyle? value) =>
                          c.updateFileViewStyle(value)),
                  RadioListTile<FileViewStyle>(
                      value: FileViewStyle.seperated,
                      title: const Text('Seperated Modifications'),
                      groupValue: c.fileViewStyle.value,
                      onChanged: (FileViewStyle? value) =>
                          c.updateFileViewStyle(value)),
                  RadioListTile<FileViewStyle>(
                      value: FileViewStyle.noChanges,
                      title: const Text('Show No Changes'),
                      groupValue: c.fileViewStyle.value,
                      onChanged: (FileViewStyle? value) =>
                          c.updateFileViewStyle(value)),
                ],
              ))),
      width: 300,
    );
  }
}
