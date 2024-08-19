import 'screens/login_page.dart';
import 'screens/home_screen.dart';
import 'screens/add_bill_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/calculation_screen.dart'; // Import your CalculationPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utility Billing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _getInitialScreen(), // Set the initial screen based on auth state
      routes: {
        '/add': (context) => AddBillScreen(),
        '/calculate': (context) =>
            CalculationPage(), // Add the route for CalculationPage
        // Additional routes can go here
      },
    );
  }

  Widget _getInitialScreen() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return HomeScreen(); // Navigate to HomeScreen if the user is logged in
    } else {
      return LoginPage(); // Navigate to LoginPage if the user is not logged in
    }
  }
}
