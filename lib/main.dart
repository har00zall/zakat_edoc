import 'dart:io';

// import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:flutter/material.dart';
import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/route.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';

const app = MyApp();

void main() async {
  // 1. Essential for any async setup in Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // init DArgon
  // DArgon2Flutter.init();
  // Request storage permission at startup
  // await _requestStoragePermission();

  await initHive();

  await initDirectories();

  // Lock to landscape
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);

  runApp(app);
}

// Future<void> _requestStoragePermission() async {
//   var status = await Permission.storage.status;
//   if (!status.isGranted) {
//     status = await Permission.storage.request();
//     if (!status.isGranted) {
//       debugPrint("Storage permission denied");
//     }
//   }
// }

Future<void> initDirectories() async {
  // final signatureDir = Directory("${Directory.current.path}/Signatures/");
  getSignatureDirectory();

  // if (await signatureDir.exists() == false) {
  //   await signatureDir.create();
  // }
}

Future<Directory?> getSignatureDirectory() async {
  // 1. Handle Web (Web does not have a "Directory" path)
  if (kIsWeb) {
    print("Web detected: File system paths are not supported.");
    return null;
  }

  // 2. Get the base path for Mobile/Desktop
  // Android: /data/user/0/com.example/app_flutter
  // Windows: C:\Users\Name\AppData\Roaming\com.example
  final Directory baseDir = await getApplicationDocumentsDirectory();

  // 3. Create the sub-folder path
  final String path = "${baseDir.path}/Signatures";
  final Directory signatureDir = Directory(path);

  // 4. Ensure the folder actually exists
  if (!await signatureDir.exists()) {
    await signatureDir.create(recursive: true);
  }

  return signatureDir;
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
