import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/provider/auth_provider.dart';

class ButtonFilled extends StatelessWidget {
  final String text;
  final Widget? widget;
  final Function() onPressed;
  const ButtonFilled(
      {required this.text, required this.onPressed, this.widget, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff4338CA);
    const secondaryColor = Color(0xff6D28D9);
    const accentColor = Color(0xffffffff);

    const double borderRadius = 15;

    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient:
              const LinearGradient(colors: [primaryColor, secondaryColor])),
      child: ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            padding: MaterialStateProperty.all(const EdgeInsets.only(
                right: 75, left: 75, top: 15, bottom: 15)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius)),
            )),
        onPressed: onPressed,
        child: Provider.of<AuthProvider>(context).isLoading
            ? LoadingAnimationWidget.inkDrop(color: Colors.white, size: 14)
            : widget ??
                Text(
                  text,
                  style: const TextStyle(color: accentColor, fontSize: 16),
                ),
      ),
    );
  }
}
