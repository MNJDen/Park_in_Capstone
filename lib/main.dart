import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/firebase_options.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:park_in/services/auth/Auth_Gate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "Park-in", options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
