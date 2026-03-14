// import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:zakat_edoc/database/user_data.dart';
import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/helpers/session_helper.dart';

enum LoginResponseCode { error, success }

class LoginResponse {
  const LoginResponse(
      {required this.responseCode, required this.responseMessage});

  final LoginResponseCode responseCode;
  final String responseMessage;
}

class LoginHelper {
  static Future<LoginResponse> login(String username, String password) async {
    var retrievedUserData = getUserWithUsername(username);

    if (retrievedUserData == null) {
      return const LoginResponse(
          responseCode: LoginResponseCode.error,
          responseMessage: "Username is not found");
    }

    // if (!(await passwordVerified(password, retrievedUserData.password))) {
    //   return const LoginResponse(
    //       responseCode: LoginResponseCode.error,
    //       responseMessage: "Wrong Password");
    // }

    if (password != retrievedUserData.password) {
      return const LoginResponse(
          responseCode: LoginResponseCode.error,
          responseMessage: "Wrong Password");
    }

    SessionHelper.addSession(
        retrievedUserData.id.toString(), retrievedUserData);
    return const LoginResponse(
        responseCode: LoginResponseCode.success,
        responseMessage: "Succesfully Logged in");
  }

  // static Future<bool> passwordVerified(
  //     String enteredPassword, String hashedPassword) async {
  //   try {
  //     return await argon2.verifyHashString(enteredPassword, hashedPassword);
  //   } catch (e) {
  //     if (e == DArgon2ErrorCode.ARGON2_VERIFY_MISMATCH) {
  //       return false;
  //     }
  //   }

  //   return false;
  // }

  static UserData? getUserWithUsername(String username) {
    for (var userData in userDB.values) {
      if (userData.username == username) {
        return userData;
      }
    }

    return null;
  }
}
