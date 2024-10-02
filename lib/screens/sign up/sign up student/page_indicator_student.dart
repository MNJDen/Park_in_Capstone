import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20student/sign_up_student1.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20student/sign_up_student2.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20student/sign_up_student3.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20student/sign_up_student4.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20student/sign_up_student5.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20student/sign_up_student6.dart';

class PageIndicatorStudent extends StatefulWidget {
  const PageIndicatorStudent({super.key});

  @override
  State<PageIndicatorStudent> createState() => _PageIndicatorStudentState();
}

class _PageIndicatorStudentState extends State<PageIndicatorStudent> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  late final List<Widget> _pages;

  // GlobalKey for SignUpStudentScreen3
  final GlobalKey<SignUpStudentScreen3State> _signUpStudentScreen3Key =
      GlobalKey<SignUpStudentScreen3State>();

  final GlobalKey<SignUpStudentScreen4State> _signUpStudentScreen4Key =
      GlobalKey<SignUpStudentScreen4State>();

  @override
  void initState() {
    super.initState();
    _pages = [
      const SignUpStudentScreen1(),
      const SignUpStudentScreen2(),
      SignUpStudentScreen3(key: _signUpStudentScreen3Key),
      SignUpStudentScreen4(key: _signUpStudentScreen4Key),
      const SignUpStudentScreen5(),
    ];
  }

  void _updateUserData() {
    switch (_currentPage) {
      case 0:
        // SignUpStudentScreen1 automatically updates the provider
        break;
      case 1:
        // SignUpStudentScreen2 automatically updates the provider
        break;
      case 2:
        // Access the _updateProviderData method via the global key
        final state = _signUpStudentScreen3Key.currentState;
        state?.updateProviderData();
        break;
      case 3:
        final state = _signUpStudentScreen4Key.currentState;
        state?.updateProviderData();
        break;
      case 4:
        break;
      // Add cases for other screens as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 20.h, 5.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () {
                            _updateUserData();
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          }
                        : () {
                            Navigator.pop(context);
                          },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: blackColor,
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
                            _updateUserData();
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
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
                                      child: SignUpStudentScreen6(),
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
                      color: blackColor,
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
                  _updateUserData(); // Update user data when page changes
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
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      height: 8.h,
      width: isActive ? 36.w : 8.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: isActive ? blueColor : blueColor.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
      ),
    );
  }
}
