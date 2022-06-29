
import 'package:flutter/material.dart';

class ModuleListTile extends StatelessWidget {
  final String text;
  final String subtitle;

  const ModuleListTile(this.text, this.subtitle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 15, bottom: 15),
      child: Container(
        width: 200,
        height: 150,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.blue.shade900]),
          // color: Colors.white70,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.05)),
          ],
        ),
        child: Column(
          children: [
            // Image.network(imageUrl, height: 70, fit: BoxFit.cover),
            const Spacer(),
            Text(text,
                textAlign: TextAlign.center,
                style:const  TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            // SizedBox(
            //   height: 5,
            // ),
            // Text(
            //   subtitle,
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //       color: Colors.grey,
            //       fontWeight: FontWeight.normal,
            //       fontSize: 12),
            // ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
