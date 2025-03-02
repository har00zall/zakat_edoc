// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authority_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthorityDataAdapter extends TypeAdapter<AuthorityData> {
  @override
  final int typeId = 3;

  @override
  AuthorityData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthorityData()
      ..ketuaBKM = fields[0] as String
      ..ketuaAmil = fields[1] as String
      ..sekretaris = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, AuthorityData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.ketuaBKM)
      ..writeByte(1)
      ..write(obj.ketuaAmil)
      ..writeByte(2)
      ..write(obj.sekretaris);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthorityDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
