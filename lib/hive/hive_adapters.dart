import 'package:hive_ce/hive.dart';
import 'package:local_db/finance.dart';
import 'package:local_db/type_enum.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<Finance>(), AdapterSpec<FinanceType>()])
// Annotations must be on some element
// ignore: unused_element
void _() {}
