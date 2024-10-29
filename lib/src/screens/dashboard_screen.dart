
import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_one/src/constants/theme.dart';

class DashboardScreen extends StatelessWidget {
  final int totalPerguntas = 10;
  final int totalRespostas = 5;
  final int conversasAtivas = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Informações do Sistema", style: Theme.of(context).textTheme.displayLarge),
            SizedBox(height: 20),
            Expanded(child: _buildBarChart()),
            SizedBox(height: 20),
            Text("Distribuição de Conversas", style: Theme.of(context).textTheme.displayLarge),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildPieChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 15,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            //getTooltipColor: Color(value).blueAccent, // Alterado para usar tooltipBgColor
            getTooltipItem: (group, groupIndex, value, title) {
              return BarTooltipItem(
                '$title\n$value',
                TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('Perguntas');
                  case 1:
                    return Text('Respostas');
                  default:
                    return Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: totalPerguntas.toDouble(),
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: totalRespostas.toDouble(),
                color: AppTheme.secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: totalPerguntas.toDouble(),
            color: AppTheme.primaryColor,
            title: '${totalPerguntas}',
          ),
          PieChartSectionData(
            value: totalRespostas.toDouble(),
            color: AppTheme.secondaryColor,
            title: '${totalRespostas}',
          ),
          PieChartSectionData(
            value: conversasAtivas.toDouble(),
            color: AppTheme.accentColor,
            title: '${conversasAtivas}',
          ),
        ],
        borderData: FlBorderData(show: false),
        centerSpaceRadius: 40,
      ),
    );
  }
}
