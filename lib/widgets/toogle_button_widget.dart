import 'package:flutter/material.dart';
import 'package:ug_hub/utils/color.dart';

class ToggleTextButtonWidget extends StatefulWidget {
  final List<Text> texts;
  final Function(int) selected;
  final Color selectedColor;
  final bool multipleSelectionsAllowed;
  final bool stateContained;
  final bool canUnToggle;
  ToggleTextButtonWidget(
      {required this.texts,
      required this.selected,
      this.selectedColor = primaryColor,
      this.stateContained = true,
      this.canUnToggle = false,
      this.multipleSelectionsAllowed = true,
      Key? key});

  @override
  _ToggleTextButtonWidgetState createState() => _ToggleTextButtonWidgetState();
}

class _ToggleTextButtonWidgetState extends State<ToggleTextButtonWidget> {
  List<bool> isSelected = [true, false, false];
  @override
  // void initState() {
  //   for (var e in widget.texts) {
  //     isSelected.add(false);
  //   }

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButtons(
            color: Colors.black.withOpacity(0.60),
            selectedColor: widget.selectedColor,
            selectedBorderColor: widget.selectedColor,
            fillColor: widget.selectedColor.withOpacity(0.08),
            splashColor: widget.selectedColor.withOpacity(0.12),
            hoverColor: widget.selectedColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(4.0),
            isSelected: isSelected,
            highlightColor: Colors.transparent,
            onPressed: (index) {
              // send callback
              widget.selected(index);
              // if you wish to have state:
              if (widget.stateContained) {
                if (!widget.multipleSelectionsAllowed) {
                  final selectedIndex = isSelected[index];
                  isSelected = isSelected.map((e) => e = false).toList();
                  if (widget.canUnToggle) {
                    isSelected[index] = selectedIndex;
                  }
                }
                setState(() {
                  isSelected[index] = !isSelected[index];
                });
              }
            },
            children: widget.texts
                .map(
                  (e) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: e,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
