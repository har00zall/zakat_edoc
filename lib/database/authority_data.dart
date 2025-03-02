import 'package:hive/hive.dart';

part 'authority_data.g.dart';

enum ZakatType { uang, beras }

@HiveType(typeId: 3)
class AuthorityData {
  @HiveField(0)
  late String ketuaBKM;

  @HiveField(1)
  late String ketuaAmil;

  @HiveField(2)
  late String sekretaris;
}
