import 'package:flutter/material.dart';
import 'package:ug_hub/utils/color.dart';

class CardFb1 extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String subtitle;
  final Function() onPressed;

  const CardFb1(
      {required this.text,
      required this.imageUrl,
      required this.subtitle,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 230,
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 1,
                color: Colors.grey.withOpacity(.07)),
          ],
        ),
        child: Column(
          children: [
            Image.network(imageUrl, height: 90, fit: BoxFit.cover),
            const Spacer(),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            // const SizedBox(
            //   height: 5,
            // ),
            // Text(
            //   subtitle,
            //   textAlign: TextAlign.center,
            //   style: const TextStyle(
            //       color: Colors.grey,
            //       fontWeight: FontWeight.normal,
            //       fontSize: 12),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
          ],
        ),
      ),
    );
  }
}
