import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
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

  late final List<Widget> _pages;

  // GlobalKey for specific screens where user data needs to be updated
  final GlobalKey<SignUpEmployeeScreen1State> _signUpEmployeeScreen1Key =
      GlobalKey<SignUpEmployeeScreen1State>();
  final GlobalKey<SignUpEmployeeScreen2State> _signUpEmployeeScreen2Key =
      GlobalKey<SignUpEmployeeScreen2State>();
  final GlobalKey<SignUpEmployeeScreen3State> _signUpEmployeeScreen3Key =
      GlobalKey<SignUpEmployeeScreen3State>();
  final GlobalKey<SignUpEmployeeScreen4State> _signUpEmployeeScreen4Key =
      GlobalKey<SignUpEmployeeScreen4State>();
  final GlobalKey<SignUpEmployeeScreen5State> _signUpEmployeeScreen5Key =
      GlobalKey<SignUpEmployeeScreen5State>();
  final GlobalKey<SignUpEmployeeScreen6State> _signUpEmployeeScreen6Key =
      GlobalKey<SignUpEmployeeScreen6State>();

  bool _isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Initialize pages with the required callbacks
    _pages = [
      SignUpEmployeeScreen1(
        key: _signUpEmployeeScreen1Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
      SignUpEmployeeScreen2(
        key: _signUpEmployeeScreen2Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
      SignUpEmployeeScreen3(
        key: _signUpEmployeeScreen3Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
      SignUpEmployeeScreen4(
        key: _signUpEmployeeScreen4Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
      SignUpEmployeeScreen5(
        key: _signUpEmployeeScreen5Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
      SignUpEmployeeScreen6(
        key: _signUpEmployeeScreen6Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
    ];

    // Schedule validation of the current page after build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateCurrentPage(); // Validate the form after widgets are mounted
    });
  }

  void _updateUserData() {
    switch (_currentPage) {
      case 0:
        _signUpEmployeeScreen1Key.currentState;
        break;
      case 1:
        _signUpEmployeeScreen2Key.currentState;
        break;
      case 2:
        _signUpEmployeeScreen3Key.currentState;
        break;
      case 3:
        _signUpEmployeeScreen4Key.currentState?.updateProviderData();
        break;
      case 4:
        _signUpEmployeeScreen5Key.currentState?.updateProviderData();
        break;
      case 5:
        _signUpEmployeeScreen6Key.currentState;
        break;
    }
  }

  void _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        final state = _signUpEmployeeScreen1Key.currentState;
        if (state != null) {
          print('isFormValid: ${state.isFormValid()}'); // Debug log
          setState(() => _isNextButtonEnabled = state.isFormValid());
        } else {
          print('State is null for SignUpEmployeeScreen1');
        }
      case 1:
        final state = _signUpEmployeeScreen2Key.currentState;
        final isValid = state?.isFormValid() ?? false;
        print('Page 2 - isFormValid: $isValid');
        setState(() => _isNextButtonEnabled = isValid);
        break;
      case 2:
        final state = _signUpEmployeeScreen3Key.currentState;
        final isValid = state?.isFormValid() ?? false;
        print('Page 3 - isFormValid: $isValid');
        setState(() => _isNextButtonEnabled = isValid);
        break;
      case 3:
        final state = _signUpEmployeeScreen4Key.currentState;
        final isValid = state?.isFormValid() ?? false;
        print('Page 4 - isFormValid: $isValid');
        setState(() => _isNextButtonEnabled = isValid);
        break;
      case 4:
        final state = _signUpEmployeeScreen5Key.currentState;
        final isValid = state?.isFormValid() ?? false;
        print('Page 5 - isFormValid: $isValid');
        setState(() => _isNextButtonEnabled = isValid);
        break;
      case 5:
        final state = _signUpEmployeeScreen6Key.currentState;
        final isValid = state?.isFormValid() ?? false;
        print('Page 6 - isFormValid: $isValid');
        setState(() => _isNextButtonEnabled = isValid);
        break;
      default:
        print('Unknown page: $_currentPage');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
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
                    onPressed: _isNextButtonEnabled
                        ? () {
                            _updateUserData();
                            if (_currentPage < _pages.length - 1) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            } else {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: Offset.zero,
                                      ).animate(CurveTween(
                                              curve: Curves
                                                  .fastEaseInToSlowEaseOut)
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
                            }
                          }
                        : null, // Disable button
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: _isNextButtonEnabled ? blackColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: _isNextButtonEnabled
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  _validateCurrentPage(); // Validate when page changes
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
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
