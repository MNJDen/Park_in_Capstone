import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/controls%20admin/announcement_btn.dart';
import 'package:park_in/components/controls%20admin/chat_btn.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/controls%20admin/ticket_btn.dart';
import 'package:park_in/screens/home%20admin/parking%20areas%20admin/parking_areas_2W_admin.dart';
import 'package:park_in/screens/home%20admin/parking%20areas%20admin/parking_areas_4W_admin.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:park_in/services/auth/Auth_Service.dart';

class HomeAdminScreen1 extends StatefulWidget {
  const HomeAdminScreen1({super.key});

  @override
  State<HomeAdminScreen1> createState() => _HomeAdminScreen1State();
}

class _HomeAdminScreen1State extends State<HomeAdminScreen1> {
  int value = 0;
  bool _isLoading = false;

  void logout(BuildContext context) async {
    final authService = AuthService();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'Confirm Sign Out',
            style: TextStyle(
              fontSize: 20.r,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
          ),
          content: Container(
            height: 40.h,
            child: Text('Are you sure you want to exit?'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: blueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Sign Out',
                style: TextStyle(color: whiteColor),
              ),
              onPressed: () async {
                try {
                  await authService.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(
                              CurveTween(curve: Curves.fastEaseInToSlowEaseOut)
                                  .animate(animation1)),
                          child: const Material(
                            elevation: 5,
                            child: SignInScreen(),
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } finally {
                  setState(
                    () {
                      _isLoading = false;
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        const AssetImage("assets/images/AdNU_Logo.png"),
                    radius: 17.r,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          "Hello, ",
                          style: TextStyle(
                            fontSize: 20.r,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(
                            fontSize: 20.r,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        Text(
                          "!",
                          style: TextStyle(
                            fontSize: 20.r,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tooltip(
                    triggerMode: TooltipTriggerMode.longPress,
                    message: "Sign Out",
                    textStyle: const TextStyle(
                      color: whiteColor,
                    ),
                    decoration: BoxDecoration(
                      color: blackColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      highlightColor: blueColor.withOpacity(0.2),
                      onPressed: () {
                        logout(context);
                      },
                      icon: const Icon(
                        Icons.logout_outlined,
                        color: blackColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                children: [
                  const Expanded(
                    child: PRKTicket(),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  const Expanded(
                    child: PRKAnnouncement(),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  const Expanded(
                    child: PRKChat(),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              AnimatedToggleSwitch<int>.size(
                current: value,
                values: const [0, 1],
                iconOpacity: 0.8,
                indicatorSize: Size.infinite,
                iconBuilder: iconBuilder,
                borderWidth: 4.0,
                iconAnimationType: AnimationType.onHover,
                style: ToggleStyle(
                    backgroundColor: const Color.fromRGBO(45, 49, 250, 0.5),
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    indicatorBorderRadius: BorderRadius.circular(6)),
                styleBuilder: (i) =>
                    const ToggleStyle(indicatorColor: blueColor),
                onChanged: (i) => setState(() => value = i),
              ),
              if (value == 0) ParkingAreas4WAdmin(),
              if (value == 1) ParkingAreas2WAdmin(),
              SizedBox(
                height: 25.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget iconBuilder(int value) {
  return iconWithTextByValue(value);
}

class IconWithText extends StatelessWidget {
  final IconData iconData;
  final String text;

  const IconWithText(this.iconData, {super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 16.r,
          color: whiteColor,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.r,
            color: whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

IconWithText iconWithTextByValue(int value) {
  final iconData = iconDataByValue(value);
  final text = iconTextByValue(value);
  return IconWithText(iconData, text: text);
}

IconData iconDataByValue(int value) {
  switch (value) {
    case 0:
      return Icons.airport_shuttle_outlined;
    case 1:
      return Icons.two_wheeler_rounded;
    default:
      return Icons.dangerous_outlined;
  }
}

String iconTextByValue(int value) {
  switch (value) {
    case 0:
      return 'Car';
    case 1:
      return 'Motorcycle';
    default:
      return 'Unknown';
  }
}
