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

  // GlobalKeys for validation
  final GlobalKey<SignUpStudentScreen1State> _signUpStudentScreen1Key =
      GlobalKey<SignUpStudentScreen1State>();
  final GlobalKey<SignUpStudentScreen2State> _signUpStudentScreen2Key =
      GlobalKey<SignUpStudentScreen2State>();
  final GlobalKey<SignUpStudentScreen3State> _signUpStudentScreen3Key =
      GlobalKey<SignUpStudentScreen3State>();
  final GlobalKey<SignUpStudentScreen4State> _signUpStudentScreen4Key =
      GlobalKey<SignUpStudentScreen4State>();
  final GlobalKey<SignUpStudentScreen5State> _signUpStudentScreen5Key =
      GlobalKey<SignUpStudentScreen5State>();

  bool _isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Initialize pages with the required callbacks
    _pages = [
      SignUpStudentScreen1(
        key: _signUpStudentScreen1Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
      SignUpStudentScreen2(
        key: _signUpStudentScreen2Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
      SignUpStudentScreen3(
        key: _signUpStudentScreen3Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
      SignUpStudentScreen4(
        key: _signUpStudentScreen4Key,
        onFormValidityChanged: (isValid) {
          // Call setState safely after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _isNextButtonEnabled = isValid);
          });
        },
      ),
      SignUpStudentScreen5(
        key: _signUpStudentScreen5Key,
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
        _signUpStudentScreen1Key.currentState;
        break;
      case 1:
        _signUpStudentScreen2Key.currentState;
        break;
      case 2:
        _signUpStudentScreen3Key.currentState?.updateProviderData();
        break;
      case 3:
        _signUpStudentScreen4Key.currentState?.updateProviderData();
        break;
      case 4:
        _signUpStudentScreen5Key.currentState;
        break;
    }
  }

  void _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        final state = _signUpStudentScreen1Key.currentState;
        if (state != null) {
          print('isFormValid: ${state.isFormValid()}'); // Debug log
          setState(() => _isNextButtonEnabled = state.isFormValid());
        } else {
          print('State is null for SignUpStudentScreen1');
        }
      case 1:
        final state = _signUpStudentScreen2Key.currentState;
        final isValid = state?.isFormValid() ?? false;
        print('Page 2 - isFormValid: $isValid');
        setState(() => _isNextButtonEnabled = isValid);
        break;
      case 2:
        final state = _signUpStudentScreen3Key.currentState;
        final isValid = state?.isFormValid() ?? false;
        print('Page 3 - isFormValid: $isValid');
        setState(() => _isNextButtonEnabled = isValid);
        break;
      case 3:
        final state = _signUpStudentScreen4Key.currentState;
        final isValid = state?.isFormValid() ?? false;
        print('Page 4 - isFormValid: $isValid');
        setState(() => _isNextButtonEnabled = isValid);
        break;
      case 4:
        final state = _signUpStudentScreen5Key.currentState;
        final isValid = state?.isFormValid() ?? false;
        print('Page 5 - isFormValid: $isValid');
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
                                        child: SignUpStudentScreen6(),
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
