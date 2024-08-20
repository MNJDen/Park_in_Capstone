import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee1.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee2.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee3.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee4.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee5.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee6.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee7.dart';

class PageIndicatorEmployee extends StatefulWidget {
  const PageIndicatorEmployee({super.key});

  @override
  State<PageIndicatorEmployee> createState() => _PageIndicatorEmployeeState();
}

class _PageIndicatorEmployeeState extends State<PageIndicatorEmployee> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    SignUpEmployeeScreen1(),
    SignUpEmployeeScreen2(),
    SignUpEmployeeScreen3(),
    SignUpEmployeeScreen4(),
    SignUpEmployeeScreen5(),
    SignUpEmployeeScreen6(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 32.h, 5.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () {
                            _controller.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }
                        : () {
                            Navigator.pop(context);
                          },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Indicator(index == _currentPage),
                    ),
                  ),
                  IconButton(
                    onPressed: _currentPage < _pages.length - 1
                        ? () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }
                        : () {
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
                                            curve:
                                                Curves.fastEaseInToSlowEaseOut)
                                        .animate(animation1)),
                                    child: const Material(
                                      elevation: 5,
                                      child: SignUpEmployeeScreen7(),
                                    ),
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 400),
                              ),
                            );
                          },
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: _pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator(this.isActive, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 10.h,
      width: isActive ? 20.w : 10.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: isActive ? blueColor : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
      ),
    );
  }
}
