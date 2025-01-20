import 'package:hive/hive.dart';
import 'package:zakat_edoc/database/user_data.dart';

part 'user_session.g.dart';

@HiveType(typeId: 1)
class UserSession {
  const UserSession({required this.sessionID, required this.userData});

  @HiveField(0)
  final String sessionID;

  @HiveField(1)
  final UserData userData;
}
