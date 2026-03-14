import 'dart:io';

// import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zakat_edoc/database/authority_data.dart';
import 'package:zakat_edoc/database/muzakki_input_data.dart';
import 'package:zakat_edoc/database/user_data.dart';
import 'package:zakat_edoc/database/user_session.dart';

const String userDatabaseName = "db_users";
const String userSessionFileName = "user_session_data";
const String authorityDataFileName = "authority_data";
const String muzakkiInputDataFileName = "muzakki_data";

late Box<UserData> userDB;
late Box<UserSession> userSession;
late Box<AuthorityData> authorityData;
late Box<MuzakkiInputData> muzakkiData;

Future<void> initHive() async {
  // init hivebox
  // init user db
  // var path = Directory.current.path;
  await Hive.initFlutter();
  Hive
    // ..init(path)
    ..registerAdapter(UserDataAdapter())
    ..registerAdapter(UserSessionAdapter())
    ..registerAdapter(AuthorityDataAdapter())
    ..registerAdapter(MuzakkiInputDataAdapter())
    ..registerAdapter(ZakatTypeAdapter());

  userDB = await Hive.openBox(userDatabaseName);
  userSession = await Hive.openBox(userSessionFileName);
  authorityData = await Hive.openBox(authorityDataFileName);
  muzakkiData = await Hive.openBox(muzakkiInputDataFileName);

  if (userDB.isEmpty) {
    // final hashedDefaultPassword =
    //     await argon2.hashPasswordString("admin", salt: Salt.newSalt());
    userDB.add(
      UserData(
          id: 0, username: "admin", password: "admin", displayName: "Admin"),
    );
  }
}
