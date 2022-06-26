import 'package:flutter/material.dart';

class PageSelector extends StatefulWidget {
  final List<String> textArray;
  final Function(int) onChange;

  const PageSelector({required this.textArray, required this.onChange, Key? key})
      : super(key: key);

  @override
  State<PageSelector> createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularArrow(
              icon:const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
              onPressed: () {
                if (_currentIndex <= 0) {
                  return;
                }
                widget.onChange(_currentIndex);
                setState(() {
                  _currentIndex -= 1;
                });
              }),
          Text(
            widget.textArray[_currentIndex],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          CircularArrow(
              icon: const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              ),
              onPressed: () {
                if (_currentIndex >= widget.textArray.length - 1) {
                  return;
                }
                widget.onChange(_currentIndex);
                setState(() {
                  _currentIndex += 1;
                });
              }),
        ],
      ),
    );
  }
}

class CircularArrow extends StatelessWidget {
  final Icon icon;
  final Function() onPressed;
  const CircularArrow({required this.icon, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: CircleAvatar(backgroundColor: Colors.blue, child: icon),
      iconSize: 25,
    );
  }
}
