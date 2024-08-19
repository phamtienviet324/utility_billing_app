import '../models/bill.dart';
import 'package:flutter/material.dart';

class BillDetailPage extends StatelessWidget {
  final Bill bill;

  BillDetailPage({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${bill.type} Bill Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bill ID: ${bill.id}'),
            Text('Electricity Usage: ${bill.electricityUsage} kWh'),
            Text('Water Usage: ${bill.waterUsage} m³'),
            Text('Total Amount: \$${bill.amount}'),
            Text('Date: ${bill.date.toLocal()}'),
          ],
        ),
      ),
    );
  }
}
