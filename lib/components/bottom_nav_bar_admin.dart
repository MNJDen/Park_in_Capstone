import 'package:flutter/material.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/screens/home%20admin/home_admin1.dart';
import 'package:park_in/screens/home%20admin/home_admin2.dart';
import 'package:park_in/screens/home%20admin/home_admin3.dart';

class BottomNavBarAdmin extends StatefulWidget {
  const BottomNavBarAdmin({super.key});

  @override
  State<BottomNavBarAdmin> createState() => _BottomNavBarAdminState();
}

class _BottomNavBarAdminState extends State<BottomNavBarAdmin> {
  final Map<int, Map<String, Widget>> _routes = {
    0: {
      '/': HomeAdminScreen1(),
    },
    1: {
      '/': HomeAdminScreen2(),
    },
    2: {
      '/': HomeAdminScreen3(),
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
      Icons.receipt_outlined,
      'Home 2',
      selectedIcon: Icon(
        Icons.receipt_rounded,
        size: 30,
        color: blueColor,
      ),
    ),
    const NavbarItem(
      Icons.campaign_outlined,
      'Home 2',
      selectedIcon: Icon(
        Icons.campaign_rounded,
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
