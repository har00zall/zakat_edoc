import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/database/authority_data.dart';
import 'package:zakat_edoc/database/muzakki_input_data.dart';
import 'package:zakat_edoc/helpers/logout_helper.dart';
import 'package:zakat_edoc/helpers/signature_painter.dart';
import 'package:zakat_edoc/route.dart';
import 'package:zakat_edoc/widgets/stateful/printing.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoggingOut = false;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeDashboard(),
    AdminSettings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: OutlinedButton.icon(
              onPressed: () {
                _onItemTapped(1);
              },
              label: Text(userSession.length == 0
                  ? ""
                  : userSession.getAt(0)!.userData.displayName),
              icon: Icon(Icons.person),
            ),
          )
        ],
        elevation: 2.5,
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Admin Settings'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox(
                height: 35,
                child: FilledButton.icon(
                  onPressed: isLoggingOut ? null : tryLogout,
                  label: Text("Log Out"),
                  icon: Icon(Icons.logout),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void tryLogout() {
    setState(() {
      isLoggingOut = true;
    });

    LogoutHelper.logout();
    backToLogin();
  }

  void backToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int baseIndex = 0;

  @override
  Widget build(BuildContext context) {
    // print("Route name: ${ModalRoute.of(context)?.settings.name}");
    double totalZakatUang = 0;
    double totalZakatBeras = 0;
    int totalMuzakki = muzakkiData.length;
    int listLength = totalMuzakki - baseIndex;
    print(listLength);

    for (var muzakki in muzakkiData.values) {
      double amount = double.tryParse(muzakki.amount) ?? 0;

      if (muzakki.zakatType == ZakatType.beras) {
        totalZakatBeras += amount;
      } else {
        totalZakatUang += amount;
      }
    }

    return ListView(
      padding: EdgeInsets.all(15),
      children: [
        Row(
          spacing: 15,
          children: [
            ReportCard(
              title: "Total Muzakki",
              data: totalMuzakki.toString(),
              backgroundColor: Theme.of(context).primaryColorLight,
            ),
            ReportCard(
              title: "Zakat Terkumpul (Uang)",
              data: "Rp. ${NumberFormat('#,##0.00').format(totalZakatUang)}",
              backgroundColor: Colors.cyan[50]!,
            ),
            ReportCard(
              title: "Zakat Terkumpul (Beras)",
              data: "${NumberFormat('#,##0.00').format(totalZakatBeras)} Kg",
              backgroundColor: Colors.teal[50]!,
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => addMuzakki),
                  );
                },
                label: Text("Tambahkan Muzakki"),
                icon: Icon(Icons.add),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.replay_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (baseIndex - 40 < 0) {
                    baseIndex = 0;
                  } else {
                    baseIndex -= 40;
                  }
                });
              },
              icon: Icon(Icons.skip_previous),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  baseIndex += 40;
                });
              },
              icon: Icon(Icons.skip_next),
            ),
            PopupMenuButton(
              onSelected: (value) {
                if (value == 0) {
                  showDialog(
                    context: context,
                    builder: (v) {
                      return AlertDialog(
                        icon: Icon(Icons.delete),
                        title: Text(
                            "Are you sure want to delete all entry ?\nThis action can't be undone"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await muzakkiData.clear();
                              setState(() {});
                            },
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              itemBuilder: (v) => [
                PopupMenuItem(
                  value: 0,
                  child: Text("Delete All"),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 1, child: TableHeader(title: "No.")),
            Expanded(flex: 5, child: TableHeader(title: "Muzakki")),
            Expanded(flex: 3, child: TableHeader(title: "Jenis Zakat")),
            Expanded(flex: 3, child: TableHeader(title: "Jumlah")),
            Expanded(flex: 1, child: TableHeader(title: "Action")),
          ],
        ),
        SizedBox(
          height: 720,
          child: ListView(
            //defaultColumnWidth: FlexColumnWidth(1),
            children: [
              ...List.generate(
                listLength,
                (index) {
                  var localIndex = baseIndex + index;
                  double zakatAmount =
                      double.tryParse(muzakkiData.getAt(localIndex)!.amount) ??
                          0;
                  return Container(
                    decoration: BoxDecoration(
                        color: localIndex % 2 == 0
                            ? Colors.white
                            : Colors.grey[200]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            flex: 1,
                            child: TableRowTextChild(
                                title: (localIndex + 1).toString())),
                        Expanded(
                            flex: 5,
                            child: TableRowTextChild(
                                title: muzakkiData.getAt(localIndex)!.name)),
                        Expanded(
                            flex: 3,
                            child: TableRowTextChild(
                                title:
                                    muzakkiData.getAt(localIndex)!.zakatType ==
                                            ZakatType.uang
                                        ? "Uang"
                                        : "Beras")),
                        Expanded(
                            flex: 3,
                            child: TableRowTextChild(
                              title:
                                  "${muzakkiData.getAt(localIndex)!.zakatType == ZakatType.uang ? "Rp." : ""} ${NumberFormat('#,##0.00').format(zakatAmount)} ${muzakkiData.getAt(localIndex)!.zakatType == ZakatType.beras ? "(Kg)" : ""}",
                            )),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: PopupMenuButton(
                              onSelected: (value) {
                                if (value == 0) {
                                  showDialog(
                                    context: context,
                                    builder: (v) {
                                      return AlertDialog(
                                        icon: Icon(Icons.delete),
                                        title: Text(
                                            "Are you sure want to delete selected entry ?\nThis action can't be undone"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);

                                              await muzakkiData
                                                  .deleteAt(localIndex);

                                              setState(() {});
                                            },
                                            child: Text(
                                              "Confirm",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (value == 1) {
                                  var groupID =
                                      muzakkiData.getAt(localIndex)?.group;
                                  List<MuzakkiInputData> muzakkiDataToPrint =
                                      [];

                                  for (var muzakki in muzakkiData.values) {
                                    if (muzakki.group == groupID) {
                                      muzakkiDataToPrint.add(muzakki);
                                    }
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Printing(
                                          muzakkiData: muzakkiDataToPrint,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              itemBuilder: (v) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text("Delete"),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    leading: Icon(Icons.print),
                                    title: Text("View"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  TextEditingController ketuaBKMTextController = TextEditingController();
  TextEditingController ketuaAmilTextController = TextEditingController();
  TextEditingController sekretarisTextController = TextEditingController();

  List<PaintingPoint?> paintingPointsKetuaBKM = [];
  List<PaintingPoint?> paintingPointsKetuaAmil = [];
  List<PaintingPoint?> paintingPointsSekretaris = [];
  final Size canvasSize = Size(600, 450);

  @override
  void initState() {
    super.initState();
    if (authorityData.isNotEmpty) {
      ketuaBKMTextController.text =
          authorityData.getAt(0)?.ketuaBKM ?? "Ketua BKM";
      ketuaAmilTextController.text =
          authorityData.getAt(0)?.ketuaAmil ?? "Ketua Amil";
      sekretarisTextController.text =
          authorityData.getAt(0)?.sekretaris ?? "Sekretaris";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "Admin Settings",
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Table(
          children: [
            TableRow(
              children: tableHeader(
                ["Ketua BKM", "Ketua 'Amil", "Sekretaris"],
              ),
            ),
            TableRow(
              children: [
                TableRowChild(
                    placeholder: "Ketua BKM",
                    controller: ketuaBKMTextController),
                TableRowChild(
                    placeholder: "Ketua 'Amil",
                    controller: ketuaAmilTextController),
                TableRowChild(
                    placeholder: "Sekretaris",
                    controller: sekretarisTextController),
              ],
            ),
            TableRow(
              children: [
                Center(
                  child: SizedBox(
                    width: canvasSize.width,
                    height: canvasSize.height,
                    child: signatureArea("ketuaBKM", paintingPointsKetuaBKM),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: canvasSize.width,
                    height: canvasSize.height,
                    child: signatureArea("ketuaAmil", paintingPointsKetuaAmil),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: canvasSize.width,
                    height: canvasSize.height,
                    child:
                        signatureArea("sekretaris", paintingPointsSekretaris),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 45,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: FilledButton.icon(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Data Telah Disimpan"),
                  ),
                );

                if (authorityData.isNotEmpty) {
                  await authorityData.clear();
                }

                var savePath = "${Directory.current.path}/Signatures";
                var ketuaBKMSignDir = "$savePath/ketuaBKMSign.png";
                var ketuaAmilSignDir = "$savePath/ketuaAmilSign.png";
                var sekretarisSignDir = "$savePath/sekretarisSign.png";
                await saveToFile(
                    paintingPoints: paintingPointsKetuaBKM,
                    customPath: ketuaBKMSignDir);
                await saveToFile(
                    paintingPoints: paintingPointsKetuaAmil,
                    customPath: ketuaAmilSignDir);
                await saveToFile(
                    paintingPoints: paintingPointsSekretaris,
                    customPath: sekretarisSignDir);

                var newAuthorityData = AuthorityData();
                newAuthorityData.ketuaBKM = ketuaBKMTextController.text;
                newAuthorityData.ketuaAmil = ketuaAmilTextController.text;
                newAuthorityData.sekretaris = sekretarisTextController.text;
                newAuthorityData.ketuaBKMSign = ketuaBKMSignDir;
                newAuthorityData.ketuaAmilSign = ketuaAmilSignDir;
                newAuthorityData.sekretarisSign = sekretarisSignDir;
                await authorityData.add(newAuthorityData);

                setState(
                  () {},
                );
              },
              label: Text("Simpan"),
              icon: Icon(Icons.save),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> tableHeader(List<String> headerTitle) {
    return List.generate(headerTitle.length, (index) {
      return TableHeader(title: headerTitle[index]);
    });
  }

  List<Widget> tableTextFieldItem(
      List<String> placeholders, TextEditingController controller) {
    return List.generate(placeholders.length, (index) {
      return TableRowChild(
        placeholder: placeholders[index],
        controller: controller,
      );
    });
  }

  Widget signatureArea(String id, List<PaintingPoint?> paintingPoints) {
    return SizedBox(
      height: canvasSize.height,
      width: canvasSize.width,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            if (localPosition.dx >= 0 &&
                localPosition.dx <= renderBox.size.width &&
                localPosition.dy >= 0 &&
                localPosition.dy <= renderBox.size.height) {
              paintingPoints.add(
                PaintingPoint(
                  offset: details.localPosition,
                  paint: Paint()
                    ..color = Colors.black
                    ..isAntiAlias = true
                    ..strokeWidth = 5
                    ..strokeCap = StrokeCap.round,
                ),
              );
            }
          });
        },
        onPanUpdate: (details) {
          setState(() {
            paintingPoints.add(
              PaintingPoint(
                offset: details.localPosition,
                paint: Paint()
                  ..color = Colors.black
                  ..isAntiAlias = true
                  ..strokeWidth = 5
                  ..strokeCap = StrokeCap.round,
              ),
            );
          });
        },
        onPanEnd: (details) {
          setState(() {
            paintingPoints.add(null);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(15),
          ),
          child: RepaintBoundary(
            child: CustomPaint(
              size: canvasSize,
              painter: SignaturePainter(paintingPoints: paintingPoints),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveToFile(
      {required List<PaintingPoint?> paintingPoints,
      String customPath = ""}) async {
    if (customPath.isEmpty) {
      customPath = "${Directory.systemTemp.path}/image.png";
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final size = canvasSize;
    final painter = SignaturePainter(paintingPoints: paintingPoints);
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final buffer = byteData.buffer.asUint8List();
      final filePath = customPath;
      await File(filePath).writeAsBytes(buffer);
      // log("File saved at: $filePath");
    }
  }

  Future<void> openFileExplorer(List<PaintingPoint?> paintingPoints) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'sign.png',
    );

    if (outputFile != null) {
      await saveToFile(paintingPoints: paintingPoints, customPath: outputFile);
    }
  }
}

class TableHeader extends StatelessWidget {
  const TableHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: GoogleFonts.rubik(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ));
  }
}

class TableRowChild extends StatelessWidget {
  const TableRowChild(
      {super.key, required this.placeholder, required this.controller});

  final String placeholder;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: placeholder,
        ),
      ),
    );
  }
}

class TableRowTextChild extends StatelessWidget {
  const TableRowTextChild({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: GoogleFonts.rubik(
          fontSize: 18,
        ),
      ),
    ));
  }
}

class ReportCard extends StatelessWidget {
  const ReportCard(
      {super.key,
      required this.title,
      required this.data,
      required this.backgroundColor});

  final String title;
  final String data;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 5),
              blurRadius: 2.5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Text(
              data,
              style: GoogleFonts.rubik(
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
