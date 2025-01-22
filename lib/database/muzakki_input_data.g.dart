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
    return MuzakkiInputData()
      ..name = fields[0] as String
      ..zakatType = fields[1] as ZakatType
      ..amount = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, MuzakkiInputData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.zakatType)
      ..writeByte(2)
      ..write(obj.amount);
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
