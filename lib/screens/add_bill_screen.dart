import '../models/bill.dart';
import 'package:flutter/material.dart';
import 'package:utility_billing/services/fire_base_auth.dart';

class AddBillScreen extends StatefulWidget {
  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'electricity';
  double _amount = 0.0;
  double _electricityUsage = 0.0;
  double _waterUsage = 0.0;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Bill',
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: _type,
                decoration: InputDecoration(
                  labelText: 'Bill Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                items: ['electricity', 'water', 'gas', 'internet']
                    .map((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      type,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _type = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _amount = double.parse(newValue!);
                },
              ),
              if (_type == 'electricity' || _type == 'water') ...[
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: _type == 'electricity'
                        ? 'Electricity Usage (kWh)'
                        : 'Water Usage (m³)',
                    prefixIcon: _type == 'electricity'
                        ? Icon(Icons.flash_on)
                        : Icon(Icons.water),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid positive number';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    if (_type == 'electricity') {
                      _electricityUsage = double.parse(newValue!);
                    } else {
                      _waterUsage = double.parse(newValue!);
                    }
                  },
                ),
              ],
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate)
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent, textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    var newBill = Bill(
                      id: '', // ID will be generated by Firestore
                      type: _type,
                      amount: _amount,
                      electricityUsage:
                          _type == 'electricity' ? _electricityUsage : 0.0,
                      waterUsage: _type == 'water' ? _waterUsage : 0.0,
                      date: _selectedDate,
                    );
                    FirebaseService().addBill(newBill);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Bill added successfully',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
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
                child: Text('Add Bill'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
