import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee1.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee2.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee3.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee4.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee5.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee6.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20employee/sign_up_employee7.dart';
import 'package:park_in/providers/user_data_provider.dart';

class PageIndicatorEmployee extends StatefulWidget {
  const PageIndicatorEmployee({super.key});

  @override
  State<PageIndicatorEmployee> createState() => _PageIndicatorEmployeeState();
}

class _PageIndicatorEmployeeState extends State<PageIndicatorEmployee> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  late final List<Widget> _pages;

  // GlobalKey for specific screens where user data needs to be updated
  final GlobalKey<SignUpEmployeeScreen5State> _signUpEmployeeScreen5Key =
      GlobalKey<SignUpEmployeeScreen5State>();

  final GlobalKey<SignUpEmployeeScreen4State> _signUpEmployeeScreen4Key =
      GlobalKey<SignUpEmployeeScreen4State>();

  @override
  void initState() {
    super.initState();
    _pages = [
      const SignUpEmployeeScreen1(),
      const SignUpEmployeeScreen2(),
      const SignUpEmployeeScreen3(),
      SignUpEmployeeScreen4(key: _signUpEmployeeScreen4Key),
      SignUpEmployeeScreen5(key: _signUpEmployeeScreen5Key),
      const SignUpEmployeeScreen6(),
    ];
  }

  void _updateUserData() {
    switch (_currentPage) {
      case 0:
        // SignUpEmployeeScreen1 automatically updates the provider
        break;
      case 1:
        // SignUpEmployeeScreen2 automatically updates the provider
        break;
      case 2:
        // Access the _updateProviderData method via the global key
        break;
      case 3:
        final state = _signUpEmployeeScreen4Key.currentState;
        state?.updateProviderData();
        break;
      case 4:
        final state = _signUpEmployeeScreen5Key.currentState;
        state?.updateProviderData();
        break;
      case 5:
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
                            _updateUserData(); // Update before going forward
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
