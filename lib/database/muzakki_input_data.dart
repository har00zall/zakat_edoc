import 'package:hive/hive.dart';

part 'muzakki_input_data.g.dart';

enum ZakatType { uang, beras }

@HiveType(typeId: 2)
class MuzakkiInputData {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late ZakatType zakatType = ZakatType.uang;

  @HiveField(2)
  late String amount;
}
