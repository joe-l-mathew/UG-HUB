import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: Colors.indigo,
  ));
}

void showMaterialBanner(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showMaterialBanner(
      const MaterialBanner(content: Text("Download started"), actions: []));
}
