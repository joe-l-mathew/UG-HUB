import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String content,{int duration =5}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: duration),
    content: Text(content),
    backgroundColor: Colors.indigo,
  ));
}

void showMaterialBanner(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showMaterialBanner(
      const MaterialBanner(content: Text("Download started"), actions: []));
}
