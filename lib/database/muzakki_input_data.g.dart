// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muzakki_input_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MuzakkiInputDataAdapter extends TypeAdapter<MuzakkiInputData> {
  @override
  final int typeId = 2;

  @override
  MuzakkiInputData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MuzakkiInputData(
      name: fields[0] as String,
      zakatType: fields[1] as ZakatType,
      amount: fields[2] as String,
      group: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MuzakkiInputData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.zakatType)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.group);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MuzakkiInputDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ZakatTypeAdapter extends TypeAdapter<ZakatType> {
  @override
  final int typeId = 4;

  @override
  ZakatType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ZakatType.uang;
      case 1:
        return ZakatType.beras;
      default:
        return ZakatType.uang;
    }
  }

  @override
  void write(BinaryWriter writer, ZakatType obj) {
    switch (obj) {
      case ZakatType.uang:
        writer.writeByte(0);
        break;
      case ZakatType.beras:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZakatTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
