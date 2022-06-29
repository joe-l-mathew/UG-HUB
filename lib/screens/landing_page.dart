import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/screens/home_screen_pages/chat_screen.dart';
import 'package:ug_hub/screens/home_screen_pages/favorite_screen.dart';
import 'package:ug_hub/screens/home_screen_pages/home_screen.dart';
import 'package:ug_hub/screens/home_screen_pages/profile_screen.dart';
import '../provider/bottom_navigation_bar_provider.dart';
import '../widgets/bottom_navigation_bar_widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomNavigationPages = const [
      HomeScreen(),
      ChatScreen(),
      FavoriteScreen(),
      ProfileScreen()
    ];

    return Scaffold(
      body: bottomNavigationPages[
          Provider.of<BottomNavigationBarProvider>(context).getPage],
      bottomNavigationBar: const CustomBottomNavigationBar(),
      // bottomNavigationBar: BottomNavBarFb2(),
    );
  }
}
