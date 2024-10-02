import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/home%20admin/controls%20admin/4W_employee_controls_admin.dart';
import 'package:park_in/screens/home%20admin/controls%20admin/4W_student_controls_admin.dart';

class PRKTabAdmin extends StatefulWidget {
  const PRKTabAdmin({super.key});

  @override
  State<PRKTabAdmin> createState() => _PRKTabAdminState();
}

class _PRKTabAdminState extends State<PRKTabAdmin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.43,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
          height: 45.h,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4.w,
          labelStyle: TextStyle(
            fontSize: 12.r,
            fontWeight: FontWeight.w500,
            color: blueColor,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12.r,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(27, 27, 27, 0.5),
          ),
        ),
        tabs: const [
          Text('Student'),
          Text('Employee'),
        ],
        views: [
          Controls4WStudentAdmin(),
          Controls4WEmployeeAdmin(),
        ],
      ),
    );
  }
}
