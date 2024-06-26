import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfoliomanagementapp/component/appbar/app_bar.dart';
import 'package:portfoliomanagementapp/component/navigation_bar/bottom_navi.dart';
import 'Themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Drawer Example',
      theme: appTheme, // Apply the global theme
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _title = 'Dashboard';

  // Define a function to handle navigation based on the selected index
  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          _title = 'Dashboards';
          break;
        case 1:
          _title = 'Applications';
          break;
        case 2:
          _title = 'Projects';
          break;
        // Add more cases if needed for additional tabs
        default:
          _title = '';
      }
    });
  }

  void _setTitle(String newTitle) {
    setState(() {
      _title = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        // Use MyAppBar
        title: _title,
        setTitle: _setTitle,
        onMenuPressed: () {},
        showAddButton:
            _title == 'Projects', // Show add button only on Projects page
      ),
      body: BottomNavigation(
        setTitle: _setTitle,
        onTabTapped: _onItemTapped,
        title: _title,
      ),
    );
  }
}
