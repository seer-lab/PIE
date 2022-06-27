import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/struct/modified_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/night-owl.dart';
import 'package:get/instance_manager.dart';

class Code extends StatelessWidget {
  final ModifiedFile file;
  final bool showAdditions, showDeletions;
  Code(
    this.file, {
    Key? key,
    this.showAdditions = false,
    this.showDeletions = false,
  }) : super(key: key);
  final UIController uiController = Get.find<UIController>();
  final double fontSize = 18.0;
  Map<String, TextStyle> theme = Map<String, TextStyle>.from(nightOwlTheme);
  double ratio = 1.17;
  Widget _createHighlight(
      int startIndex, int difference, bool isAddition, BuildContext context) {
    return Positioned(
        top: startIndex.toDouble() * (fontSize * ratio),
        child: Container(
          color: (isAddition)
              ? Colors.green.withOpacity(0.7)
              : Colors.red.withOpacity(0.7),
          //height: (difference).toDouble() * (ratio * fontSize),
          child: Text(
            ((isAddition) ? '+ \n' : '- \n') * difference,
            style: TextStyle(fontSize: fontSize),
          ),
          width: 10,
        ));
  }

  List<Widget> _getAddedHighlight(List<Diff> additions, BuildContext context) {
    if (!showAdditions) return [];
    List<Widget> highlights = [];
    for (int i = 0; i < additions.length; i++) {
      highlights.add(_createHighlight(additions[i].index - 1,
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
    }
    return highlights;
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
    return Stack(
      children: [
        // ..._getModificationHighlight(file.content, context),
        ..._getAddedHighlight(file.added, context),
        ..._getDeletedHighlight(file.deleted, context),
        SizedBox(
            width: uiController.getCodeEditorWidth(context),
            child: HighlightView(
              file.content,
              padding: const EdgeInsets.only(left: 13),
              language: file.language,
              textStyle:
                  TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
              theme: theme,
            )),
      ],
    );
  }
}
