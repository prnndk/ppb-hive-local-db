import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce/hive.dart';
import 'package:local_db/finance.dart';
import 'package:local_db/finance_card.dart';
import 'package:local_db/finance_overview.dart';
import 'package:local_db/finance_statistic.dart';
import 'package:local_db/type_enum.dart';

class FinanceList extends StatefulWidget {
  const FinanceList({super.key});

  @override
  State<FinanceList> createState() => _FinanceListState();
}

class _FinanceListState extends State<FinanceList> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  FinanceType _selectedType = FinanceType.income;

  @override
  Widget build(BuildContext context) {
    final financeData = Hive.box<Finance>('myBox').values;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FinanceOverview(
              totalAmount: financeData.fold(
                0,
                (sum, item) => sum + item.amount,
              ),
            ),
            FinanceStatistic(finances: financeData.toList()),
            SizedBox(height: 5.0),
            Text(
              'Finance Record',
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  //clear the text fields
                  _nameController.clear();
                  _amountController.clear();

                  openCreateDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Buat Data Baru',
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(fontSize: 16),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  financeData.isEmpty
                      ? const Center(
                        child: Text("Currently no transaction has been made"),
                      )
                      : ListView.builder(
                        itemCount: financeData.length,
                        itemBuilder: (context, index) {
                          final finance = financeData.toList()[index];
                          return FinanceCard(
                            finance: finance,
                            delete: () {
                              setState(() {
                                // finances.removeAt(index);
                                Hive.box<Finance>('myBox').delete(finance.key);
                              });
                            },
                            edit: () {
                              openEditDialog(index);
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Future openCreateDialog() => showDialog(
    context: context,
    builder:
        (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Buat data baru',
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Masukkan Nama Pencatatan',
                    ),
                  ),
                  TextField(
                    controller: _amountController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Besaran Uang'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pilih Tipe Pencatatan',
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  DropdownButton<FinanceType>(
                    value: _selectedType,
                    isExpanded: true,
                    onChanged: (FinanceType? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                    items:
                        FinanceType.values.map((FinanceType type) {
                          return DropdownMenuItem<FinanceType>(
                            value: type,
                            child: Text(
                              type.toString().split('.').last,
                            ), // Hanya ambil nama enum
                          );
                        }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel, color: Colors.redAccent),
                      SizedBox(width: 5),
                      Text('Cancel', style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    double? amount = double.tryParse(_amountController.text);
                    if (_nameController.text.isNotEmpty && amount != null) {
                      setState(() {
                        Hive.box<Finance>('myBox').add(
                          Finance(
                            id: Hive.box<Finance>('myBox').length + 1,
                            name: _nameController.text,
                            amount: amount,
                            type: _selectedType,
                          ),
                        );
                      });

                      _nameController.clear();
                      _amountController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil menambahkan data"),
                          backgroundColor: Colors.green.shade300,
                        ),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Mohon isi nama dan jumlah dengan benar",
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.blue),
                      SizedBox(width: 5),
                      Text('Create', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
  );

  Future openEditDialog(int index) {
    final finance = Hive.box<Finance>('myBox').getAt(index);
    if (finance != null) {
      _nameController.text = finance.name;
      _amountController.text = finance.amount.toString();
      _selectedType = finance.type;
      return showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                'Ubah Data',
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nama Pencatatan'),
                  ),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: 'Besaran Uang'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pilih Tipe Pencatatan',
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  DropdownButton<FinanceType>(
                    value: _selectedType,
                    isExpanded: true,
                    onChanged: (FinanceType? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                    items:
                        FinanceType.values.map((FinanceType type) {
                          return DropdownMenuItem<FinanceType>(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          );
                        }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _nameController.clear();
                    _amountController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel, color: Colors.redAccent),
                      SizedBox(width: 5),
                      Text('Cancel', style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    double? amount = double.tryParse(_amountController.text);
                    if (_nameController.text.isNotEmpty && amount != null) {
                      setState(() {
                        Hive.box<Finance>('myBox').put(
                          finance.key,
                          Finance(
                            id: finance.id,
                            name: _nameController.text,
                            amount: amount,
                            type: _selectedType,
                          ),
                        );
                      });

                      _nameController.clear();
                      _amountController.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil menambahkan data"),
                          backgroundColor: Colors.green.shade300,
                        ),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Mohon isi nama dan jumlah dengan benar",
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          'Edit Data',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      );
    }

    return showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Text("Data is null"),
            ),
          ),
    );
  }
}
