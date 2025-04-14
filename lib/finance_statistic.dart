import 'package:flutter/material.dart';
import 'package:local_db/finance.dart';
import 'package:local_db/helper/rupiah_format.dart';
import 'package:local_db/type_enum.dart';

class FinanceStatistic extends StatelessWidget {
  final List<Finance> finances;

  const FinanceStatistic({super.key, required this.finances});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      color: Colors.blue.shade400,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Finance Statistic',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            SizedBox(height: 10.0),
            ...FinanceType.values.map((type) {
              int count =
                  finances.where((finance) => finance.type == type).length;
              double totalAmount = finances
                  .where((finance) => finance.type == type)
                  .fold(0, (sum, finance) => sum + finance.amount);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${type.toString().split('.').last} ($count)',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    Text(
                      RupiahFormat.formatDouble(totalAmount),
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
