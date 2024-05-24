import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:portfoliomanagementapp/component/comming_soon/commingsoon.dart';
import 'package:portfoliomanagementapp/dashboard.dart';
import 'package:portfoliomanagementapp/applications.dart';
import 'package:portfoliomanagementapp/resources/app_colors.dart';
import 'package:portfoliomanagementapp/projects.dart';

class BottomNavigation extends StatefulWidget {
  final void Function(int index) onTabTapped;
  final String title;
  final void Function(String newTitle)
      setTitle; // Add a callback function to update the title

  const BottomNavigation({
    Key? key,
    required this.onTabTapped,
    required this.title,
    required this.setTitle, // Initialize the callback function
  }) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_page),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColors.bottomNavi,
        color: AppColors.bottomNavi,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.dashboard, size: 26, color: Colors.white),
          Icon(Icons.app_shortcut, size: 26, color: Colors.white),
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.message, size: 26, color: Colors.white),
          Icon(Icons.notifications, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
            widget.onTabTapped(index);
            // Update the title indirectly through the callback function
            switch (index) {
              case 0:
                widget.setTitle('Dashboards');
                break;
              case 1:
                widget.setTitle('Applications');
                break;
              case 2:
                widget.setTitle('Projects');
                break;
              default:
                widget.setTitle('TEST');
            }
          });
        },
      ),
    );
  }

  Widget _getPage(int page) {
    switch (page) {
      case 0:
        return const DashboardPage();
      case 1:
        return ApplicationPage();
      case 2:
        return const ProjectPage(); // Pass showAddButton
      default:
        return const DefaultPage();
    }
  }
}
