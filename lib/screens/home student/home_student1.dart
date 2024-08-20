import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/screens/home%20student/notification_student.dart';
import 'package:park_in/screens/home%20student/parking%20areas%20student/parking_areas_2W_student.dart';
import 'package:park_in/screens/home%20student/parking%20areas%20student/parking_areas_4W_student.dart';

class HomeStudentScreen1 extends StatefulWidget {
  const HomeStudentScreen1({super.key});

  @override
  State<HomeStudentScreen1> createState() => _HomeStudentScreen1State();
}

class _HomeStudentScreen1State extends State<HomeStudentScreen1> {
  int value = 0;

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
                height: 32.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: const Color.fromRGBO(45, 49, 250, 0.5),
                    highlightColor: const Color.fromRGBO(45, 49, 250, 0.5),
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {},
                    child: Card(
                      elevation: 0,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        "assets/images/AdNU_Logo.png",
                        fit: BoxFit.fill,
                        height: 40.h,
                        width: 40.w,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Hello, Den!",
                      style: TextStyle(
                        fontSize: 20.r,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    splashColor: const Color.fromRGBO(45, 49, 250, 0.5),
                    highlightColor: const Color.fromRGBO(45, 49, 250, 0.5),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (BuildContext context,
                              Animation<double> animation1,
                              Animation<double> animation2) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(CurveTween(
                                      curve: Curves.fastEaseInToSlowEaseOut)
                                  .animate(animation1)),
                              child: const Material(
                                elevation: 5,
                                child: NotificationStudentScreen(),
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: blackColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 28.h,
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
              if (value == 0) ParkingArea4WStudent(),
              if (value == 1) ParkingArea2W(),
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
