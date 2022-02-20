import 'package:emonit/theme/colors.dart';
import 'package:emonit/views/login_page.dart';
import 'package:emonit/views/initial_page.dart';         
import 'package:emonit/views/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
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
        ChangeNotifierProvider(create: (context) {
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-monit',
        initialRoute: '/',
        routes: {
          '/login': (context) => const LoginPage(),
          '/signUp': (context) => const SignUpPage(),
          '/initialPage': (context) => const InitialPage()
        },
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: kWhite,
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: kWhite),
            ),
            backgroundColor: kWhite),
        home: const MySplashScreen(),
      ),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
        imageSrc: 'assets/logo_telkom.png',
        backgroundColor: kRed,
        imageSize: 90,
        text: 'E-monit',
        textType: TextType.NormalText,
        textStyle: const TextStyle(
            fontSize: 40, color: kWhite, fontWeight: FontWeight.bold),
        duration: 3000,
        navigateRoute: const LoginPage());
  }
}
