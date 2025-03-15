import 'package:hive/hive.dart';

part 'muzakki_input_data.g.dart';

@HiveType(typeId: 4)
enum ZakatType {
  @HiveField(0)
  uang,
  @HiveField(1)
  beras
}

@HiveType(typeId: 2)
class MuzakkiInputData {
  MuzakkiInputData({required this.name, required this.zakatType, required this.amount, required this.group});

  @HiveField(0)
  String name;

  @HiveField(1)
  ZakatType zakatType = ZakatType.uang;

  @HiveField(2)
  String amount;

  @HiveField(3)
  String group;
}
