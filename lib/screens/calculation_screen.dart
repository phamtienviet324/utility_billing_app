import '../models/bill.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../services/fire_base_auth.dart';

class CalculationPage extends StatefulWidget {
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  final _electricityController = TextEditingController();
  final _waterController = TextEditingController();
  double _electricityBill = 0.0;
  double _waterBill = 0.0;

  void _calculateAndSaveBill() {
    double electricityUsage =
        double.tryParse(_electricityController.text) ?? 0.0;
    double waterUsage = double.tryParse(_waterController.text) ?? 0.0;

    // Calculate electricity and water bills
    _electricityBill = _calculateElectricityBill(electricityUsage);
    _waterBill = _calculateWaterBill(waterUsage);

    // Save bill to Firebase
    _saveBill(electricityUsage, waterUsage, _electricityBill + _waterBill);

    setState(() {});
  }

  double _calculateElectricityBill(double usage) {
    double bill = 0.0;
    if (usage <= 50) {
      bill = usage * 1.678;
    } else if (usage <= 100) {
      bill = 50 * 1.678 + (usage - 50) * 1.734;
    } else if (usage <= 200) {
      bill = 50 * 1.678 + 50 * 1.734 + (usage - 100) * 2.014;
    } else {
      bill = 50 * 1.678 + 50 * 1.734 + 100 * 2.014 + (usage - 200) * 2.536;
    }
    return bill;
  }

  double _calculateWaterBill(double usage) {
    double pricePerCubicMeter = 5.0;
    return usage * pricePerCubicMeter;
  }

  void _saveBill(
      double electricityUsage, double waterUsage, double totalAmount) {
    var bill = Bill(
      id: Uuid().v4(),
      type: 'Combined',
      amount: totalAmount,
      electricityUsage: electricityUsage,
      waterUsage: waterUsage,
      date: DateTime.now(),
    );

    FirebaseService().addBill(bill); // Save to Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculate Bills',
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _electricityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Electricity Usage (kWh)',
                prefixIcon: Icon(Icons.flash_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _waterController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Water Usage (m³)',
                prefixIcon: Icon(Icons.water),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _calculateAndSaveBill,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: Text('Calculate and Save'),
              ),
            ),
            SizedBox(height: 30),
            if (_electricityBill > 0 || _waterBill > 0)
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill Summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Divider(),
                      Text(
                        'Electricity Bill: \$${_electricityBill.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Water Bill: \$${_waterBill.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
