import 'dart:io';
import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hive/hive.dart';
import 'package:zakat_edoc/database/user_data.dart';
import 'package:zakat_edoc/db_route.dart';
import 'package:zakat_edoc/route.dart';

const app = MyApp();

void main() async {
  // init DArgon
  DArgon2Flutter.init();

  // init hivebox
  // init user db
  var path = Directory.current.path;
  Hive
    ..init(path)
    ..registerAdapter(UserDataAdapter());
  userDB = await Hive.openBox(userDatabaseName);

  if (userDB.isEmpty) {
    final hashedDefaultPassword =
        await argon2.hashPasswordString("admin", salt: Salt.newSalt());
    userDB.add(UserData(
        id: 0,
        username: "admin",
        password: hashedDefaultPassword.encodedString,
        displayName: "Admin"));
  }

  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'App',
      home: login,
      locale: Locale("id"),
    );
  }
}
