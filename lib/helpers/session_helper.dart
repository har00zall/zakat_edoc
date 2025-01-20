import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/database/user_data.dart';
import 'package:zakat_edoc/database/user_session.dart';

class SessionHelper {
  static void addSession(String id, UserData userData) async {
    if (userSession.length > 1) {
      await clearSession();
    }
    await userSession.add(
      UserSession(sessionID: id, userData: userData),
    );
  }

  static Future<void> clearSession() async {
    await userSession.clear();
  }
}
