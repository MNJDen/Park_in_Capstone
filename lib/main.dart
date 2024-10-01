import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/services/notification/notification_service.dart';
import 'package:park_in/splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(10000),
      channelKey: message.notification?.title == "Announcement"
          ? 'announcements_channel'
          : 'violations_channel',
      title: message.notification?.title,
      body: message.notification?.body,
      notificationLayout: NotificationLayout.Default,
    ),
  );
}

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // initialize fcm and set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // initialize awesome notifications
  AwesomeNotifications().initialize(
    // 'asset://assets/images/notif_icon.png',
    null,
    [
      NotificationChannel(
        channelKey: 'announcements_channel',
        channelName: 'Announcements',
        channelDescription: 'Notification channel for announcements',
        defaultColor: blueColor,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
        channelKey: 'violations_channel',
        channelName: 'Parking Violations',
        channelDescription: 'Notification channel for parking violations',
        defaultColor: Colors.red,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: "basic_channelGroupKey",
          channelGroupName: "basic_channelGroupName")
    ],
  );
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final userType = prefs.getString('userType');
  final userId = prefs.getString('userId');

  // initialize the notification service globally
  if (userId != null && userType != null) {
    final notificationService =
        NotificationService(userId: userId, userType: userType);
    notificationService.init();
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: blackColor,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(isLoggedIn: isLoggedIn, userType: userType),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userType;

  const MyApp({required this.isLoggedIn, required this.userType, super.key});

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
          home: SplashScreen(isLoggedIn: isLoggedIn, userType: userType),
        );
      },
    );
  }
}
