import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/utils/color.dart';

import '../provider/bottom_navigation_bar_provider.dart';

class BottomNavBarFb2 extends StatelessWidget {
  const BottomNavBarFb2({Key? key}) : super(key: key);

  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconBottomBar(
                  text: "",
                  icon: Icons.home,
                  selected: true,
                  onPressed: () {
                    Provider.of<BottomNavigationBarProvider>(context,
                            listen: false)
                        .setPage = 0;
                  }),
              IconBottomBar(
                  text: "",
                  icon: Icons.chat,
                  selected: false,
                  onPressed: () {
                    Provider.of<BottomNavigationBarProvider>(context,
                            listen: false)
                        .setPage = 1;
                  }),
              IconBottomBar(
                  text: "",
                  icon: Icons.favorite,
                  selected: false,
                  onPressed: () {
                    Provider.of<BottomNavigationBarProvider>(context,
                            listen: false)
                        .setPage = 2;
                  }),
              IconBottomBar(
                  text: "",
                  icon: Icons.person,
                  selected: false,
                  onPressed: () {
                    Provider.of<BottomNavigationBarProvider>(context,
                            listen: false)
                        .setPage = 3;
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  final primaryColor = const Color(0xff4338CA);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 25,
            color: selected ? primaryColor : Colors.black54,
          ),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 12,
              height: .1,
              color: selected ? primaryColor : Colors.grey.withOpacity(.75)),
        )
      ],
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        elevation: 0,
        selectedIconTheme: IconThemeData(color: primaryColor),
        enableFeedback: true,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: Provider.of<BottomNavigationBarProvider>(context).getPage,
        unselectedItemColor: Colors.grey.withOpacity(.75),
        selectedItemColor: primaryColor,
        onTap: ((value) =>
            Provider.of<BottomNavigationBarProvider>(context, listen: false)
                .setPage = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorit"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ]);
  }
}
