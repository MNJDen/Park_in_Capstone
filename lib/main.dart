import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_employee.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_student.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/firebase_options.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/screens/home%20admin/home_admin.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "Park-in", options: DefaultFirebaseOptions.currentPlatform);

  // Check if the user is logged in and get their user type
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final userType = prefs.getString('userType');

  // Determine the initial screen based on user type
  Widget initialScreen = const SignInScreen();

  if (isLoggedIn && userType != null) {
    switch (userType) {
      case 'Admin':
        initialScreen = const HomeAdminScreen1();
        break;
      case 'Student':
        initialScreen = const BottomNavBarStudent();
        break;
      case 'Employee':
        initialScreen = const BottomNavBarEmployee();
        break;
      default:
        initialScreen = const SignInScreen();
    }
  } else {
    initialScreen = const SignInScreen();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(initialScreen: initialScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({required this.initialScreen, super.key});

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
          home: initialScreen,
        );
      },
    );
  }
}
