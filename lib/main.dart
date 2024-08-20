import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/firebase_options.dart';
import 'package:park_in/services/auth/Auth_Gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "Park-in", options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Park-in',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'General Sans',
          ).copyWith(
            colorScheme: ThemeData().colorScheme.copyWith(primary: blueColor),
          ),
          home: AuthGate(),
        );
      },
    );
  }
}
