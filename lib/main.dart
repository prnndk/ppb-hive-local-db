import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:local_db/finance.dart';
import 'package:local_db/finance_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_db/hive/hive_adapters.dart';
import 'package:local_db/hive/hive_registrar.g.dart';
import 'package:local_db/type_enum.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocument = await getApplicationDocumentsDirectory();

  await Hive.initFlutter(appDocument.path);

  Hive.registerAdapters();

  await Hive.openBox<Finance>('myBox');

  final box = Hive.box<Finance>('myBox');

  if (box.isEmpty) {
    box.addAll([
      Finance(
        id: 1,
        name: 'Beli makan',
        amount: 15000.00,
        type: FinanceType.food,
      ),
      Finance(
        id: 2,
        name: 'Beli minum',
        amount: 5000.00,
        type: FinanceType.food,
      ),
      Finance(
        id: 3,
        name: 'Bayar UKT',
        amount: 3000000.00,
        type: FinanceType.education,
      ),
      Finance(
        id: 4,
        name: 'Beli buku',
        amount: 150000.00,
        type: FinanceType.entertainment,
      ),
      Finance(
        id: 5,
        name: 'Beli baju',
        amount: 15000.00,
        type: FinanceType.shopping,
      ),
      Finance(
        id: 6,
        name: 'Beli makan',
        amount: 15000.00,
        type: FinanceType.food,
      ),
      Finance(
        id: 7,
        name: 'Beli bensin',
        amount: 55000.00,
        type: FinanceType.transport,
      ),
    ]);
  }

  runApp(MaterialApp(home: MyApp(), theme: _buildTheme(Brightness.light)));
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(
    brightness: brightness,
    primaryColor: Colors.blueAccent,
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Financial Application',
          style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 1.0,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(child: FinanceList())],
        ),
      ),
    );
  }
}
