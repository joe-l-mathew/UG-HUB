import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/provider/internet_provider.dart';

Future<bool> checkInternet({bool isHome = false}) async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
  } else {
    if (isHome) {
      showSimpleNotification(
          const Text(
            'You are not connected to internet,you can still use our app but some features might not work',
            textAlign: TextAlign.center,
          ),
          background: Colors.red,
          slideDismissDirection: DismissDirection.up,
          duration: const Duration(seconds: 5));
    }
  }
  return result;
}
