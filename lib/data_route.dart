import 'dart:io';

import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:hive/hive.dart';
import 'package:zakat_edoc/database/user_data.dart';
import 'package:zakat_edoc/database/user_session.dart';

const String userDatabaseName = "db_users";
const String userSessionFileName = "user_session_data";

late Box<UserData> userDB;
late Box<UserSession> userSession;

Future<void> initHive() async {
  // init hivebox
  // init user db
  var path = Directory.current.path;
  Hive
    ..init(path)
    ..registerAdapter(UserDataAdapter())
    ..registerAdapter(UserSessionAdapter());

  userDB = await Hive.openBox(userDatabaseName);
  userSession = await Hive.openBox(userSessionFileName);

  if (userDB.isEmpty) {
    final hashedDefaultPassword =
        await argon2.hashPasswordString("admin", salt: Salt.newSalt());
    userDB.add(
      UserData(
          id: 0,
          username: "admin",
          password: hashedDefaultPassword.encodedString,
          displayName: "Admin"),
    );
  }
}
