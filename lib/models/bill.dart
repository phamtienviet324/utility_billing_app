import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  String id;
  String type;
  double amount;
  double electricityUsage;
  double waterUsage;
  DateTime date;

  Bill({
    required this.id,
    required this.type,
    required this.amount,
    required this.electricityUsage,
    required this.waterUsage,
    required this.date,
  });

  // Method to create a Bill object from a Firestore document
  factory Bill.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Bill(
      id: doc.id,
      type: data['type'] ?? '',
      amount: data['amount']?.toDouble() ?? 0.0,
      electricityUsage: data['electricityUsage']?.toDouble() ?? 0.0,
      waterUsage: data['waterUsage']?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Method to convert a Bill object into a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'amount': amount,
      'electricityUsage': electricityUsage,
      'waterUsage': waterUsage,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp
    };
  }
}
