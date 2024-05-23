import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:portfoliomanagementapp/resources/app_colors.dart';

class LineChartViewer extends StatefulWidget {
  const LineChartViewer({super.key});

  @override
  State<LineChartViewer> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartViewer> {
  List<Color> gradientColors = [
    AppColors.chartBelowDataStart,
    AppColors.chartBelowDataEnd,
  ];
  List<Color> gradientColors2 = [
    AppColors.chartBelowDataStart,
    AppColors.chartBelowDataStart,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1000,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 0,
                left: 0,
                top: 24,
                bottom: 0,
              ),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget topTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Color(0xFF7484B6),
    );

    Widget text;
    if (value > 0 && value < 32) {
      if (value == 32) {
        text = Text('', style: style);
      } else {
        text = Text('${value.toInt()}', style: style);
      }
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xFF7484B6),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 31,
            interval: 1,
            getTitlesWidget: topTitleWidgets,
          ),
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xFF414C82)),
      ),
      minX: 0,
      maxX: 14,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 3),
            FlSpot(4, 4),
            FlSpot(5, 3),
            FlSpot(6, 4),
            FlSpot(7, 3),
            FlSpot(8, 2),
            FlSpot(9, 5),
            FlSpot(10, 3),
            FlSpot(11, 4),
            FlSpot(12, 3),
            FlSpot(13, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors2,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.2))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
