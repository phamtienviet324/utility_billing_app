import '../models/bill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/fire_base_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utility_billing/screens/login_page.dart'; // Import your LoginScreen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Utility Billing',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Sign out the user
              await FirebaseAuth.instance.signOut();
              // Navigate to LoginScreen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: StreamProvider<List<Bill>>(
        create: (context) => FirebaseService().getBills(),
        initialData: [],
        child: BillList(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
            backgroundColor: Colors.green,
            tooltip: 'Add New Bill',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/calculate');
            },
            backgroundColor: Colors.orange,
            tooltip: 'Calculate Costs',
            child: Icon(Icons.calculate),
          ),
        ],
      ),
    );
  }
}

class BillList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Bill> bills = Provider.of<List<Bill>>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: bills.length,
        itemBuilder: (context, index) {
          var bill = bills[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(
                Icons.receipt_long,
                color: Colors.blueAccent,
                size: 40,
              ),
              title: Text(
                '${bill.type} Bill',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                '\$${bill.amount}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              trailing: Text(
                '${bill.date.toLocal()}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
