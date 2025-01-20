import 'dart:io';

import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: login,
    );
  }
}
