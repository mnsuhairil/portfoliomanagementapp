import 'package:flutter/material.dart';

// import 'package:portfoliomanagementapp/resources/app_colors.dart';
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function() onMenuPressed;
  final void Function(String newTitle)
      setTitle; // Callback function to update the title

  const MyAppBar({
    Key? key,
    required this.title,
    required this.onMenuPressed,
    required this.setTitle, // Initialize the callback function
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: Color(0xFFFFFDFF),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      actions: [
        // IconButton(
        //   icon: const Icon(
        //     Icons.menu,
        //     color: Color(0xFF8999D7),
        //   ),
        //   onPressed: onMenuPressed,
        // ),
        Padding(
          padding: const EdgeInsets.all(5.0),
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
