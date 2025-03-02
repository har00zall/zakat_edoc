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
  @HiveField(0)
  late String name;

  @HiveField(1)
  late ZakatType zakatType = ZakatType.uang;

  @HiveField(2)
  late String amount;
}
