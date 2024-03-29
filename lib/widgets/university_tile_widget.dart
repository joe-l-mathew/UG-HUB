import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ug_hub/provider/university_provider.dart';
import 'package:ug_hub/utils/color.dart';

class CardFb1 extends StatelessWidget {
  final int? consIndex;
  final String text;
  final String imageUrl;
  final String subtitle;
  final Function() onPressed;

  const CardFb1(
      {required this.text,
      required this.imageUrl,
      required this.subtitle,
      required this.onPressed,
      Key? key,
      this.consIndex})
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
          border: Border.all(
              color: Provider.of<UniversityProvider>(context).selectedIndex ==
                      consIndex
                  ? primaryColor
                  : Colors.grey.withOpacity(.05)),
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
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 90,
              width: 90,
              fit: BoxFit.cover,
              progressIndicatorBuilder: ((context, url, progress) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    height: 90,
                    width: 90,
                  ),
                );
              }),
            ),
            const Spacer(),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
          ],
        ),
      ),
    );
  }
}
