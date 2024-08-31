import 'package:flutter/material.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/screens/home%20student/home_student1.dart';
import 'package:park_in/screens/home%20student/home_student2.dart';

class BottomNavBarStudent extends StatefulWidget {
  const BottomNavBarStudent({super.key});

  @override
  State<BottomNavBarStudent> createState() => _BottomNavBarStudentState();
}

class _BottomNavBarStudentState extends State<BottomNavBarStudent> {
  final Map<int, Map<String, Widget>> _routes = {
    0: {
      '/': HomeStudentScreen1(),
    },
    1: {
      '/': HomeStudentScreen2(),
    },
  };

  List<NavbarItem> items = [
    const NavbarItem(
      Icons.grid_view_outlined,
      'Home 1',
      selectedIcon: Icon(
        Icons.grid_view_rounded,
        size: 30,
        color: blueColor,
      ),
    ),
    const NavbarItem(
      Icons.new_releases_outlined,
      'Home 2',
      selectedIcon: Icon(
        Icons.new_releases_rounded,
        size: 30,
        color: blueColor,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavbarRouter(
      type: NavbarType.floating,
      errorBuilder: (context) {
        return const Center(child: Text('Error 404 Page Not Found'));
      },
      onBackButtonPressed: (isExiting) {
        return isExiting;
      },
      destinationAnimationCurve: Curves.fastOutSlowIn,
      destinationAnimationDuration: 500,
      decoration: FloatingNavbarDecoration(
        backgroundColor: whiteColor,  
        showSelectedLabels: false,
        selectedIconColor: blueColor,
        unselectedIconColor: const Color.fromRGBO(45, 49, 250, 0.4),
        borderRadius: BorderRadius.circular(10),
        isExtended: true,
      ),
      destinations: [
        for (int i = 0; i < items.length; i++)
          DestinationRouter(
            navbarItem: items[i],
            destinations: [
              for (int j = 0; j < _routes[i]!.keys.length; j++)
                Destination(
                  route: _routes[i]!.keys.elementAt(j),
                  widget: _routes[i]!.values.elementAt(j),
                ),
            ],
            initialRoute: _routes[i]!.keys.first,
          ),
      ],
    );
  }
}
