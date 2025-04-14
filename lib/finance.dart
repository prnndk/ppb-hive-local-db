import 'package:hive_ce/hive.dart';
import 'package:local_db/type_enum.dart';

class Finance extends HiveObject {
  final int id;
  final String name;
  final double amount;
  final FinanceType type;

  Finance({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
  });
}
