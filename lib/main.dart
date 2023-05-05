import 'package:ark/Screens/homePage.dart';
import 'package:ark/Screens/mainScreen.dart';
import 'package:ark/Widgets/location.dart';
import 'package:ark/Login/logIn.dart';
import 'package:ark/back_services.dart';
import 'package:ark/Widgets/pickFile.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ark/Login/verify.dart';
import 'package:background_service/background_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Login/signIn.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

Future main() async {
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  BackgroundService.initialize(onStart);
  BackgroundService().sendData(action: "setAsBackground");
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: splash());
  }
}

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'images/exam.png',
      nextScreen: LogIn(),
      splashTransition: SplashTransition.rotationTransition,
      duration: 3000,
    );
  }
}
