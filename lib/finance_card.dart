import 'package:flutter/material.dart';
import 'package:local_db/finance.dart';
import 'package:local_db/helper/rupiah_format.dart';

class FinanceCard extends StatelessWidget {
  final Finance finance;
  final VoidCallback delete;
  final VoidCallback edit;

  const FinanceCard({
    super.key,
    required this.finance,
    required this.delete,
    required this.edit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              finance.name,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 6.0),

            Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  margin: EdgeInsets.only(right: 8.0, top: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade200,
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.label, size: 16.0, color: Colors.white),
                      SizedBox(width: 6.0),
                      Text(
                        finance.type.toString().split('.').last,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.0),
            Divider(thickness: 1.2, color: Colors.grey[300]),

            // Jumlah Uang
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Jumlah:",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    RupiahFormat.formatDouble(finance.amount),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),

            Divider(thickness: 1.2, color: Colors.grey[300]),
            SizedBox(height: 8.0),

            // Tombol Edit & Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: edit,
                  icon: Icon(Icons.edit, size: 18),
                  label: Text('Ubah Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: delete,
                  icon: Icon(Icons.delete, size: 18),
                  label: Text('Hapus Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
