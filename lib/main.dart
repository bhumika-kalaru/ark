import 'package:ark/Screens/homePage.dart';
import 'package:ark/Screens/mainScreen.dart';
import 'package:ark/Widgets/location.dart';
import 'package:ark/Login/logIn.dart';
import 'package:ark/back_services.dart';
import 'package:ark/Widgets/pickFile.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ark/Login/verify.dart';
import 'package:ark/constants.dart';
import 'package:background_service/background_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_mode/permission_handler.dart';
import 'Login/signIn.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  BackgroundService.initialize(onStart);
  BackgroundService().sendData(action: "setAsBackground");
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color? textColor = maincolour; // the desired text color
    final ThemeData theme = Theme.of(context);

    // textTheme:
    // GoogleFonts.sourceSansProTextTheme();
    final TextTheme textTheme = theme.textTheme.copyWith(
      bodyText1: TextStyle(color: textColor),
      bodyText2: TextStyle(color: textColor),
      headline1: TextStyle(color: textColor),
      headline2: TextStyle(color: textColor),
      headline3: TextStyle(color: textColor),
      headline4: TextStyle(color: textColor),
      headline5: TextStyle(color: textColor),
      headline6: TextStyle(color: textColor),
      caption: TextStyle(color: textColor),
      button: TextStyle(color: textColor),
      subtitle1: TextStyle(color: textColor),
      subtitle2: TextStyle(color: textColor),
      overline: TextStyle(color: textColor),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: textTheme,
          backgroundColor: cream,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: pink),
          // ignore: deprecated_member_use
          primarySwatch: MaterialColor(0xff2B3467, {
            50: Color(0xff2B3467),
            100: Color(0xff2B3467),
            200: Color(0xff2B3467),
            300: Color(0xff2B3467),
            400: Color(0xff2B3467),
            500: Color(0xff2B3467),
            600: Color(0xff2B3467),
            700: Color(0xff2B3467),
            800: Color(0xff2B3467),
            900: Color(0xff2B3467),
          }),
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
