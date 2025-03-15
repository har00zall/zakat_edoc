import 'dart:io';

import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:flutter/material.dart';
import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/route.dart';

const app = MyApp();

void main() async {
  // init DArgon
  DArgon2Flutter.init();

  await initHive();

  await initDirectories();

  runApp(app);
}

Future<void> initDirectories() async {
  final signatureDir = Directory("${Directory.current.path}/Signatures/");

  if (await signatureDir.exists() == false) {
    await signatureDir.create();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: userSession.length > 0 ? dashboard : login,
      locale: Locale("id"),
    );
  }
}
