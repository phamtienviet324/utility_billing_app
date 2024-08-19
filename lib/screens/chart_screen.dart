import '../models/bill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:utility_billing/services/fire_base_auth.dart';

class ChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: StreamProvider<List<Bill>>(
        create: (context) => FirebaseService().getBills(),
        initialData: [],
        child: BillChart(),
      ),
    );
  }
}

class BillChart extends StatelessWidget {
  final List<Color> colorPalette = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    var bills = Provider.of<List<Bill>>(context);
    Map<String, double> dataMap = {};

    for (var bill in bills) {
      if (dataMap.containsKey(bill.type)) {
        dataMap[bill.type] = dataMap[bill.type]! + bill.amount;
      } else {
        dataMap[bill.type] = bill.amount;
      }
    }

    double totalAmount = dataMap.values.fold(0, (sum, value) => sum + value);

    List<PieChartSectionData> sections = [];
    int colorIndex = 0;

    dataMap.forEach((type, amount) {
      sections.add(PieChartSectionData(
        title: type,
        value: amount,
        color: colorPalette[colorIndex % colorPalette.length],
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
      colorIndex++;
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total: \$${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 60,
              sectionsSpace: 2,
            ),
          ),
        ],
      ),
    );
  }
}
