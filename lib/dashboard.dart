import 'package:flutter/material.dart';
import 'package:portfoliomanagementapp/component/chart/line_chart/line_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedMonthIndex = 0; // Index of the selected month

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cards
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double cardWidth = constraints.maxWidth / 3 - 16;
              double cardHeight = 100;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCard(
                        Icons.face, 'Viewer', '10', cardWidth, cardHeight),
                    _buildCard(Icons.bookmark_add_rounded, 'Projects', '16',
                        cardWidth, cardHeight),
                    _buildCard(
                        Icons.thumb_up, 'Likes', '126', cardWidth, cardHeight),
                  ],
                ),
              );
            },
          ),
        ),
        // Filter box with months
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(12, (index) {
                return _buildFilterChip(index);
              }),
            ),
          ),
        ),
        // Line chart
        const Expanded(
          child: LineChartViewer(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(int index) {
    bool isSelected = _selectedMonthIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMonthIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Chip(
          label: Text(
            _months[index],
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF7484B6),
            ),
          ),
          backgroundColor:
              isSelected ? const Color(0xFF7484B6) : const Color(0xFF414C82),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: Color(0xFF7484B6)),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      IconData icon, String text1, String text2, double width, double height) {
    return Card(
      color: const Color(0xFF303962),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF7484B6)),
            const SizedBox(height: 4),
            Text(
              text1,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF556198),
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              text2,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFDFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
}
