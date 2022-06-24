import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/auth_methods.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/provider/branch_provider.dart';
import 'package:ug_hub/provider/university_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/flash_screen.dart';
import 'package:ug_hub/screens/home_screen.dart';
import 'package:ug_hub/screens/login_screen.dart';
// import 'package:ug_hub/screens/otp_screen.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/university_tile_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BranchProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UniversityProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UG HUB',
          theme: ThemeData(primarySwatch: primaryColor),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const FlashScreen();
                  // return CustomCarouselFB2();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const LoginScreen();
            },
          )
          // const LoginScreen(),
          // home: OtpScreen(phoneNo: '9496283576'),
          ),
    );
  }
}
