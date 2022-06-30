import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/struct/modified_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/night-owl.dart';
import 'package:get/instance_manager.dart';

class Code extends StatelessWidget {
  final ModifiedFile file;
  final bool showAdditions, showDeletions;
  final double? width;
  Code(this.file,
      {Key? key,
      this.showAdditions = false,
      this.showDeletions = false,
      this.width})
      : super(key: key);
  final UIController uiController = Get.find<UIController>();
  final double fontSize = 18.0;
  Map<String, TextStyle> theme = Map<String, TextStyle>.from(nightOwlTheme);
  double ratio = 1.17;
  Widget _createHighlight(
      int startIndex, int difference, bool isAddition, BuildContext context) {
    return Positioned(
        top: startIndex.toDouble() * (fontSize * ratio),
        left: 5,
        child: Container(
          color: (isAddition) ? Colors.green : Colors.red,
          //height: (difference).toDouble() * (ratio * fontSize),
          child: Text(
            ((isAddition) ? '+ \n' : '- \n') * difference,
            style: TextStyle(fontSize: fontSize),
          ),
          width: 10,
        ));
  }

  Widget _createDropShaddow(
      int startIndex, int difference, bool isAddition, BuildContext context) {
    return Positioned(
        top: startIndex.toDouble() * (fontSize * ratio),
        left: 20,
        child: Container(
          color: (isAddition)
              ? Colors.green.withOpacity(0.02)
              : Colors.red.withOpacity(0.02),
          //height: (difference).toDouble() * (ratio * fontSize),
          child: Text(
            ((isAddition) ? '+ \n' : '- \n') * difference,
            style: TextStyle(fontSize: fontSize, color: Colors.transparent),
          ),
          width: width ?? 0,
        ));
  }

  List<Widget> _getAddedHighlight(List<Diff> additions, BuildContext context) {
    if (!showAdditions) return [];
    List<Widget> highlights = [];
    for (int i = 0; i < additions.length; i++) {
      highlights.add(_createHighlight(additions[i].index - 1,
          additions[i].content.split('\n').length, true, context));
      highlights.add(_createDropShaddow(additions[i].index - 1,
          additions[i].content.split('\n').length, true, context));
    }
    return highlights;
  }

  List<Widget> _getDeletedHighlight(
      List<Diff> deletions, BuildContext context) {
    if (!showDeletions) return [];
    List<Widget> highlights = [];
    for (int i = 0; i < deletions.length; i++) {
      highlights.add(_createHighlight(deletions[i].index - 1,
          deletions[i].content.split('\n').length, false, context));
      highlights.add(_createDropShaddow(deletions[i].index - 1,
          deletions[i].content.split('\n').length, false, context));
    }
    return highlights;
  }

  @override
  Widget build(BuildContext context) {
    theme['root'] = const TextStyle(
        color: Color(0xffabb2bf), backgroundColor: Colors.transparent);
    return Stack(
      children: [
        // ..._getModificationHighlight(file.content, context),
        ..._getAddedHighlight(file.added, context),
        ..._getDeletedHighlight(file.deleted, context),
        SizedBox(
            width: uiController.getCodeEditorWidth(context),
            child: HighlightView(
              file.content,
              padding: const EdgeInsets.only(left: 20),
              language: file.language,
              textStyle:
                  TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
              theme: theme,
            )),
      ],
    );
  }
}
