import 'package:hive/hive.dart';

part 'authority_data.g.dart';

@HiveType(typeId: 3)
class AuthorityData {
  @HiveField(0)
  late String ketuaBKM;

  @HiveField(1)
  late String ketuaAmil;

  @HiveField(2)
  late String sekretaris;

  @HiveField(3)
  late String ketuaBKMSign;

  @HiveField(4)
  late String ketuaAmilSign;

  @HiveField(5)
  late String sekretarisSign;
}
