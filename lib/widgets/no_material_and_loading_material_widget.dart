import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/color.dart';

class MaterialLoadingCustom extends StatelessWidget {
  const MaterialLoadingCustom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset("assets/loading.json"));
  }
}

class NoMaterialFound extends StatelessWidget {
  const NoMaterialFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Lottie.asset("assets/no_file.json", repeat: false)),
        const Text(
          "No Material Found",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: primaryColor),
        )
      ],
    );
  }
}
