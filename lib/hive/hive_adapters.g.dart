// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class FinanceAdapter extends TypeAdapter<Finance> {
  @override
  final int typeId = 0;

  @override
  Finance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Finance(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      amount: (fields[2] as num).toDouble(),
      type: fields[3] as FinanceType,
    );
  }

  @override
  void write(BinaryWriter writer, Finance obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinanceTypeAdapter extends TypeAdapter<FinanceType> {
  @override
  final int typeId = 1;

  @override
  FinanceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FinanceType.income;
      case 1:
        return FinanceType.expense;
      case 2:
        return FinanceType.transfer;
      case 3:
        return FinanceType.food;
      case 4:
        return FinanceType.transport;
      case 5:
        return FinanceType.shopping;
      case 6:
        return FinanceType.entertainment;
      case 7:
        return FinanceType.health;
      case 8:
        return FinanceType.education;
      default:
        return FinanceType.income;
    }
  }

  @override
  void write(BinaryWriter writer, FinanceType obj) {
    switch (obj) {
      case FinanceType.income:
        writer.writeByte(0);
      case FinanceType.expense:
        writer.writeByte(1);
      case FinanceType.transfer:
        writer.writeByte(2);
      case FinanceType.food:
        writer.writeByte(3);
      case FinanceType.transport:
        writer.writeByte(4);
      case FinanceType.shopping:
        writer.writeByte(5);
      case FinanceType.entertainment:
        writer.writeByte(6);
      case FinanceType.health:
        writer.writeByte(7);
      case FinanceType.education:
        writer.writeByte(8);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinanceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
