import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/components/violation_card.dart';
import 'package:park_in/screens/drawer/about.dart';
import 'package:park_in/screens/drawer/faqs.dart';
import 'package:park_in/screens/drawer/report.dart';
import 'package:park_in/screens/drawer/settings/change_password.dart';
import 'package:park_in/screens/drawer/settings/personal_details.dart';
import 'package:park_in/screens/drawer/settings/stickers.dart';
import 'package:park_in/screens/home%20student/notification_student.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:park_in/services/auth/Auth_Service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeStudentScreen2 extends StatefulWidget {
  final String userId; // Current logged-in user's ID
  final String userType;

  const HomeStudentScreen2({
    Key? key,
    required this.userType,
    required this.userId,
  }) : super(key: key);

  @override
  State<HomeStudentScreen2> createState() => _HomeStudentScreen2State();
}

class _HomeStudentScreen2State extends State<HomeStudentScreen2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late BehaviorSubject<DocumentSnapshot<Map<String, dynamic>>> userSubject;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userSubject = BehaviorSubject();
    _fetchUserData();
    _getUserStream(); // Fetch the user's data when the screen initializes
  }

  void logout(BuildContext context) async {
    final authService = AuthService();

    setState(() {
      _isLoading = true;
    });

    try {
      await authService.signOut();
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation1,
              Animation<double> animation2) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)
                  .animate(animation1)),
              child: const Material(
                elevation: 5,
                child: SignInScreen(),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  List<String>? _plateNumbers; // Holds the current user's plate number

  // Function to fetch the user's data
  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.userId) // Get the document with the current user's ID
          .get();

      final plateNoField = userDoc['plateNo']; // This might be a List or String

      setState(() {
        if (plateNoField is List) {
          _plateNumbers =
              plateNoField.map((plate) => plate.toString()).toList();
        } else {
          _plateNumbers =
              plateNoField != null ? [plateNoField.toString()] : null;
        }
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _getUserStream() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .snapshots()
          .listen((snapshot) {
        userSubject.add(snapshot);
      });
    }
  }

  String formatOffenseNumber(int number) {
    if (number == 1) {
      return '1st offense';
    } else if (number == 2) {
      return '2nd offense';
    } else if (number == 3) {
      return '3rd offense';
    } else {
      return '${number}th offense';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      drawer: Drawer(
        backgroundColor: whiteColor,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userSubject.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching user data'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('User not found'));
            }

            final userData = snapshot.data!;
            final String name = userData['name'] ?? 'N/A';
            final String userNumber = userData['userNumber'] ?? 'N/A';
            final String profilePicture =
                userData['profilePicture'] ?? "assets/images/AdNU_Logo.png";
            return Column(
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/bg1.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            profilePicture,
                            height: 70.h,
                            width: 70.w,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/AdNU_Logo.png",
                                height: 70.h,
                                width: 70.w,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16.r,
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          userNumber,
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          childrenPadding: EdgeInsets.only(left: 12.w),
                          expansionAnimationStyle: AnimationStyle(
                              curve: Curves.fastLinearToSlowEaseIn),
                          leading: Icon(
                            Icons.manage_accounts_outlined,
                            color: blackColor,
                            size: 24.r,
                          ),
                          title: Text(
                            'Account Settings',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.account_box_outlined,
                                color: blackColor,
                                size: 24.r,
                              ),
                              title: Text(
                                "Personal Details",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: blackColor,
                                ),
                              ),
                              onTap: () {
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
                                                curve: Curves
                                                    .fastEaseInToSlowEaseOut)
                                            .animate(animation1)),
                                        child: const Material(
                                          elevation: 5,
                                          child: PersonalDetailsScreen(),
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.shield_outlined,
                                color: blackColor,
                                size: 24.r,
                              ),
                              title: Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: blackColor,
                                ),
                              ),
                              onTap: () {
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
                                                curve: Curves
                                                    .fastEaseInToSlowEaseOut)
                                            .animate(animation1)),
                                        child: const Material(
                                          elevation: 5,
                                          child: ChangePasswordScreen(),
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.confirmation_num_outlined,
                                color: blackColor,
                                size: 24.r,
                              ),
                              title: Text(
                                "Stickers",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: blackColor,
                                ),
                              ),
                              onTap: () {
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
                                                curve: Curves
                                                    .fastEaseInToSlowEaseOut)
                                            .animate(animation1)),
                                        child: const Material(
                                          elevation: 5,
                                          child: StickersScreen(),
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.flag_outlined,
                          color: blackColor,
                          size: 24.r,
                        ),
                        title: Text(
                          'Report',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        onTap: () {
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
                                    child: ReportScreen(),
                                  ),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.question_answer_outlined,
                          color: blackColor,
                          size: 24.r,
                        ),
                        title: Text(
                          'FAQs',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        onTap: () {
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
                                    child: FaqsScreen(),
                                  ),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.people_outline_rounded,
                          color: blackColor,
                          size: 24.r,
                        ),
                        title: Text(
                          'About Park-in',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        onTap: () {
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
                                    child: AboutScreen(),
                                  ),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: PRKPrimaryBtn(
                    label: "Sign Out",
                    onPressed: () {
                      logout(context);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          NavbarNotifier.hideBottomNavBar = false;
        }
      },
      body: SafeArea(
        child: SingleChildScrollView(
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
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                      NavbarNotifier.hideBottomNavBar = true;
                    },
                    child: Card(
                      elevation: 0,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: FutureBuilder<String?>(
                        future: _getUserId(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            return StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: userSubject.stream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Icon(Icons.error, color: blackColor);
                                } else if (snapshot.hasData) {
                                  final profilePicUrl =
                                      snapshot.data?['profilePicture'] ??
                                          "assets/images/default_profile.png";
                                  return Image.network(
                                    profilePicUrl,
                                    fit: BoxFit.fill,
                                    height: 40.h,
                                    width: 40.w,
                                  );
                                } else {
                                  return Icon(Icons.error, color: blackColor);
                                }
                              },
                            );
                          } else {
                            return Icon(Icons.error, color: blackColor);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: userSubject.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final userData = snapshot.data!;
                          final String name =
                              userData['name'] ?? 'Hello, User!';
                          return Text(
                            "Hello, $name!",
                            style: TextStyle(
                              fontSize: 20.r,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                          );
                        } else {
                          return Text(
                            'Hello, User!',
                            style: TextStyle(
                              fontSize: 20.r,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  FutureBuilder<String?>(
                    future: _getUserId(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error, color: blackColor);
                      } else if (snapshot.hasData) {
                        final userId = snapshot.data;
                        return IconButton(
                          splashColor: const Color.fromRGBO(45, 49, 250, 0.5),
                          highlightColor:
                              const Color.fromRGBO(45, 49, 250, 0.5),
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
                                            curve:
                                                Curves.fastEaseInToSlowEaseOut)
                                        .animate(animation1)),
                                    child: Material(
                                      elevation: 5,
                                      child: NotificationStudentScreen(
                                        userType: 'Student',
                                        userId: userId!,
                                      ),
                                    ),
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 400),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: blackColor,
                            size: 30,
                          ),
                        );
                      } else {
                        return Icon(Icons.error, color: blackColor);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 28.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Violations Committed",
                    softWrap: true,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 16.r,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Violation Ticket')
                    .where('plate_number', whereIn: _plateNumbers)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching tickets'));
                  } else if (snapshot.hasData) {
                    final tickets = snapshot.data!.docs.map((doc) {
                      return doc.data() as Map<String, dynamic>;
                    }).toList();

                    if (tickets.isEmpty) {
                      return Center(child: Text('No violation tickets found'));
                    } else {
                      // Sort tickets by timestamp
                      tickets.sort((a, b) {
                        return (a['timestamp'] as Timestamp)
                            .compareTo(b['timestamp'] as Timestamp);
                      });

                      return Column(
                        children: List.generate(tickets.length, (index) {
                          final ticket = tickets[index];
                          return Column(
                            children: [
                              PRKViolationCard(
                                offenseNumber: formatOffenseNumber(index + 1),
                                date: (ticket['timestamp'] as Timestamp)
                                    .toDate()
                                    .toString()
                                    .split(' ')[0],
                                violation: ticket['violation'],
                              ),
                              SizedBox(height: 12.h),
                            ],
                          );
                        }),
                      );
                    }
                  } else {
                    return Center(child: Text('No violation tickets found'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
