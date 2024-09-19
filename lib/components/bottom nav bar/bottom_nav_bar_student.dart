import 'package:flutter/material.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/screens/home%20student/home_student1.dart';
import 'package:park_in/screens/home%20student/home_student2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBarStudent extends StatefulWidget {
  const BottomNavBarStudent({super.key});

  @override
  State<BottomNavBarStudent> createState() => _BottomNavBarStudentState();
}

class _BottomNavBarStudentState extends State<BottomNavBarStudent> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _loadUserId() async {
    final userId = await _getUserId();
    setState(() {
      _userId = userId;
    });
  }

  List<NavbarItem> items = [
    const NavbarItem(
      Icons.grid_view_outlined,
      'Home',
      selectedIcon: Icon(
        Icons.grid_view_rounded,
        size: 30,
        color: blueColor,
      ),
    ),
    const NavbarItem(
      Icons.new_releases_outlined,
      'Violation',
      selectedIcon: Icon(
        Icons.new_releases_rounded,
        size: 30,
        color: blueColor,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(), // Display a loading indicator until _userId is available
        ),
      );
    }

    final Map<int, Map<String, Widget>> routes = {
      0: {
        '/': HomeStudentScreen1(),
      },
      1: {
        '/': HomeStudentScreen2(userId: _userId!, userType: 'Student'),
      },
    };

    return NavbarRouter(
      type: NavbarType.floating,
      errorBuilder: (context) {
        return const Center(child: Text('Error 404 Page Not Found'));
      },
      onBackButtonPressed: (isExiting) {
        return isExiting;
      },
      destinationAnimationCurve: Curves.fastOutSlowIn,
      destinationAnimationDuration: 0,
      decoration: FloatingNavbarDecoration(
        backgroundColor: whiteColor,
        showSelectedLabels: false,
        selectedIconColor: blueColor,
        unselectedIconColor: blueColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        isExtended: true,
      ),
      destinations: [
        for (int i = 0; i < items.length; i++)
          DestinationRouter(
            navbarItem: items[i],
            destinations: [
              for (int j = 0; j < routes[i]!.keys.length; j++)
                Destination(
                  route: routes[i]!.keys.elementAt(j),
                  widget: routes[i]!.values.elementAt(j),
                ),
            ],
            initialRoute: routes[i]!.keys.first,
          ),
      ],
    );
  }
}
