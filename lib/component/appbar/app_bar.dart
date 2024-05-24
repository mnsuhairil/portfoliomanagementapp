import 'package:flutter/material.dart';
import 'package:portfoliomanagementapp/add_project_page.dart';

// import 'package:portfoliomanagementapp/resources/app_colors.dart';
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function() onMenuPressed;
  final void Function(String newTitle)
      setTitle; // Callback function to update the title
  final bool showAddButton; // Flag to control the add button visibility

  const MyAppBar({
    Key? key,
    required this.title,
    required this.onMenuPressed,
    required this.setTitle, // Initialize the callback function
    required this.showAddButton, // Add showAddButton parameter
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showAddButton
          ? IconButton(
              icon: const Icon(
                Icons.add,
                color: Color(0xFF8999D7),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AddProjectPage()), // Navigate to AddProjectPage
                );
              },
            )
          : null, // Conditional rendering based on showAddButton
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: Color(0xFFFFFDFF),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/150', // Placeholder image URL
            ),
          ),
        ),
      ],
    );
  }
}
