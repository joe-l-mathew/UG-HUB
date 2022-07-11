import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/provider/add_module_toggle_provider.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/provider/bottom_navigation_bar_provider.dart';
import 'package:ug_hub/provider/branch_provider.dart';
import 'package:ug_hub/provider/display_pdf_provider.dart';
import 'package:ug_hub/provider/module_model_provider.dart';
import 'package:ug_hub/provider/university_provider.dart';
import 'package:ug_hub/provider/upload_pdf_provider.dart';
import 'package:ug_hub/provider/upload_status_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/flash_screen.dart';
import 'package:ug_hub/screens/login_screen.dart';
import 'package:ug_hub/utils/color.dart';
import 'admob/admob_provider.dart';

//need to change sha256 on real build
// addd network check always
//add orderby (assending) to all screen
//make selected true for list tilekk
//tile image backup
//https://github.com/miguelpruivo/flutter_file_picker/wiki file picker
//fix color issue with dilouge(select branch)
//auto otp read
//https://pub.dev/packages/url_launcher add to manifest
//add time and is teacher to user
//add view sylabus done
//chech internet

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdmobProvider()),
        ChangeNotifierProvider(create: (context) => DisplayPdfProvider()),
        ChangeNotifierProvider(create: (context) => UploadStatusProvider()),
        ChangeNotifierProvider(create: (context) => ModuleModelProvider()),
        ChangeNotifierProvider(create: (context) => UploadPdfProvider()),
        ChangeNotifierProvider(create: (context) => AddModuleToggleProvider()),
        ChangeNotifierProvider(
            create: (context) => BottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (context) => BranchProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UniversityProvider())
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'UG HUB',
            theme: ThemeData(primarySwatch: Colors.indigo)
                .copyWith(primaryColor: primaryColor),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const FlashScreen();
                    // return OtpScreen(phoneNo: 'phoneNo');
                    // return CustomCarouselFB2();
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                          'Please check your internet connection and try again'),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    backgroundColor: HexColor('#4438ca'),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icon.png',
                            scale: 0.9,
                          ),
                          LoadingAnimationWidget.fourRotatingDots(
                              color: Colors.white, size: 30),
                        ],
                      ),
                    ),
                  );
                }
                return const LoginScreen();
              },
            )
            // const LoginScreen(),
            // home: OtpScreen(phoneNo: '9496283576'),
            ),
      ),
    );
  }
}
