// lib/applications.dart
import 'package:flutter/material.dart';
import 'ManagePorrtfolioPage.dart'; // Import ManagePortfolioPage

Widget createManagePortfolioPage() {
  return ManagePortfolioPage();
}

class ApplicationPage extends StatelessWidget {
  // Sample application data (replace with your actual data)
  final List<Map<String, dynamic>> applications = [
    {
      'image': 'lib/assets/images/personalportfolio.png',
      'name': 'Manage Portfolio Web',
      'widget': createManagePortfolioPage(),
    },
    // {
    //   'image': 'lib/assets/images/personalportfolio.png',
    //   'name': 'App Name 2',
    //   'widget': YourWidget2(),
    // },
    // {
    //   'image': 'lib/assets/images/personalportfolio.png',
    //   'name': 'App Name 3',
    //   'widget': YourWidget3(),
    // },
    // Add more applications here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: applications.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final app = applications[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => app['widget'] as Widget,
                ),
              );
            },
            child: ApplicationItem(
              image: app['image'],
              name: app['name'],
            ),
          );
        },
      ),
    );
  }
}

class ApplicationItem extends StatelessWidget {
  final String image;
  final String name;

  const ApplicationItem({
    Key? key,
    required this.image,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          height: 80,
          width: 80,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
