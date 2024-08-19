import '../models/bill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utility_billing/screens/bill_detail_screen.dart';

class BillList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Bill> bills = Provider.of<List<Bill>>(context);
    return ListView.builder(
      itemCount: bills.length,
      itemBuilder: (context, index) {
        var bill = bills[index];
        return ListTile(
          title: Text('${bill.type} Bill'),
          subtitle: Text('\$${bill.amount}'),
          trailing: Text('${bill.date.toLocal()}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BillDetailPage(bill: bill)),
            );
          },
        );
      },
    );
  }
}
