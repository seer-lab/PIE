import 'package:code_editor/code_editor.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:get/instance_manager.dart';

class Code extends StatelessWidget {
  final FileEditor file;
  Code(this.file, {Key? key}) : super(key: key);
  final UIController uiController = Get.find<UIController>();
  final double fontSize = 14.0;
  Map<String, TextStyle> theme = Map<String, TextStyle>.from(atomOneDarkTheme);

  Widget _createHighlight(
      int startIndex, int difference, bool isAddition, BuildContext context) {
    return Positioned(
        top: startIndex.toDouble() * (fontSize + 2),
        child: Container(
          color: (isAddition!)
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          height: (difference).toDouble() * (2 + fontSize),
          width: uiController.getCodeEditorWidth(context),
        ));
  }

  List<Widget> _getModificationHighlight(String code, BuildContext context) {
    List<Widget> highlights = [];

    int startIndex = -1;
    bool? isAddition;
    code.split('\n').asMap().forEach((index, element) {
      if (element.isNotEmpty) {
        if (element[0] == '-' || element[0] == '+') {
          if (isAddition == null) {
            startIndex = index;
            isAddition = element[0] == '+';
          } else {
            if ((isAddition! && element[0] == '-') ||
                (!isAddition! && element[0] == '+')) {
              highlights.add(_createHighlight(
                  startIndex, index - startIndex, isAddition!, context));
              startIndex = index;
              isAddition = element[0] == '+';
            }
          }
        } else if (isAddition != null) {
          highlights.add(_createHighlight(
              startIndex, index - startIndex, isAddition!, context));
          isAddition = null;
          startIndex = -1;
        }
      }
    });
    if (isAddition != null) {
      highlights.add(_createHighlight(startIndex,
          code.split('\n').length - startIndex, isAddition!, context));
    }
    return highlights;
  }

  @override
  Widget build(BuildContext context) {
    theme['root'] = const TextStyle(
        color: Color(0xffabb2bf), backgroundColor: Colors.transparent);
    return SingleChildScrollView(
        child: SizedBox(
            width: uiController.getCodeEditorWidth(context),
            child: Stack(
              children: [
                ..._getModificationHighlight(
                    file.code ?? "No Code Available.", context),
                SizedBox(
                    width: uiController.getCodeEditorWidth(context),
                    child: HighlightView(
                      file.code ?? "No Code Available.",
                      language: file.language,
                      textStyle: TextStyle(fontSize: fontSize),
                      theme: theme,
                    )),
              ],
            )));
  }
}
