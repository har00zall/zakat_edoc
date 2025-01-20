import 'package:zakat_edoc/helpers/session_helper.dart';

class LogoutHelper {
  static Future<void> logout() async {
    await SessionHelper.clearSession();
  }
}
