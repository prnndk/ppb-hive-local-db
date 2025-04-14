import 'package:flutter/material.dart';
import 'package:local_db/helper/rupiah_format.dart';

class FinanceOverview extends StatelessWidget {
  final double totalAmount;

  const FinanceOverview({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      color: Colors.blue.shade400,
      child: Padding(padding: EdgeInsets.all(12.0), child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Total Finance Amount',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          SizedBox(height: 10.0),
          Text(
            RupiahFormat.formatDouble(totalAmount),
            style: TextStyle(fontSize: 24.0, color: Colors.white),
          ),
        ],
      ),
      ),
    );
  }
}
