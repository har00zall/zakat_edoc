import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/database/muzakki_input_data.dart';
import 'package:zakat_edoc/helpers/signature_painter.dart';
import 'package:zakat_edoc/widgets/stateful/printing.dart';

class MuzakkiInputController {
  const MuzakkiInputController({
    required this.muzakkiInputData,
    required this.nameFieldController,
    required this.zakatTypeFieldController,
    required this.amountFieldController,
  });

  final TextEditingController nameFieldController;
  final TextEditingController zakatTypeFieldController;
  final TextEditingController amountFieldController;

  final MuzakkiInputData muzakkiInputData;
}

class AddMuzakki extends StatefulWidget {
  const AddMuzakki({super.key});

  @override
  State<AddMuzakki> createState() => _AddMuzakkiState();
}

class _AddMuzakkiState extends State<AddMuzakki> {
  List<MuzakkiInputController> muzakkiEntry = [];
  List<PaintingPoint?> paintingPoints = [];

  final Size canvasSize = Size(600, 450);

  late String groupName;

  bool saved = false;

  @override
  void initState() {
    super.initState();
    groupName = generateRandomString(16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Muzakki",
          style: GoogleFonts.rubik(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: OutlinedButton.icon(
              onPressed: () async {
                await saveAndPrintReceipt();
              },
              label: Text("Save & Print"),
              icon: Icon(Icons.print),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: List.generate(
              muzakkiEntry.length,
              (index) {
                return ListTile(
                  key: ValueKey(muzakkiEntry[index]),
                  leading: Text(
                    "${index + 1}",
                    style: GoogleFonts.rubik(fontSize: 14),
                  ),
                  tileColor: index.isOdd ? Colors.black12 : Colors.white,
                  trailing: IconButton.outlined(
                    onPressed: () async {
                      await removeEntry(index);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  title: Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          key: ValueKey(muzakkiEntry[index]),
                          controller: muzakkiEntry[index].nameFieldController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Nama Muzakki",
                          ),
                          onChanged: (value) {
                            setState(
                              () {
                                onChange();
                                muzakkiEntry[index].muzakkiInputData.name =
                                    value;
                              },
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: DropdownMenu(
                          key: ValueKey(muzakkiEntry[index]),
                          controller:
                              muzakkiEntry[index].zakatTypeFieldController,
                          expandedInsets: EdgeInsets.all(10),
                          label: Text("Tipe Barang Zakat"),
                          dropdownMenuEntries: [
                            DropdownMenuEntry(
                                value: ZakatType.uang, label: "Uang"),
                            DropdownMenuEntry(
                                value: ZakatType.beras, label: "Beras")
                          ],
                          onSelected: (value) {
                            setState(
                              () {
                                onChange();
                                if (value == null) {
                                  muzakkiEntry[index]
                                      .zakatTypeFieldController
                                      .text = "Uang";
                                }
                                muzakkiEntry[index].muzakkiInputData.zakatType =
                                    value ?? ZakatType.uang;
                              },
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          key: ValueKey(muzakkiEntry[index]),
                          controller: muzakkiEntry[index].amountFieldController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText:
                                "Nominal (${muzakkiEntry[index].muzakkiInputData.zakatType == ZakatType.uang ? "Rp." : "Kg"})",
                          ),
                          onChanged: (value) {
                            setState(
                              () {
                                onChange();
                                muzakkiEntry[index].muzakkiInputData.amount =
                                    value.replaceAll(RegExp(r','), '');
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox(
              height: 35,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(
                    () {
                      muzakkiEntry.add(
                        MuzakkiInputController(
                          muzakkiInputData: MuzakkiInputData(
                              name: "",
                              zakatType: ZakatType.uang,
                              amount: "",
                              group: muzakkiEntry.isNotEmpty
                                  ? muzakkiEntry[0].muzakkiInputData.name
                                  : ""),
                          nameFieldController: TextEditingController(),
                          zakatTypeFieldController: TextEditingController(),
                          amountFieldController: TextEditingController(),
                        ),
                      );
                    },
                  );
                },
                label: Text("Tambah Muzakki"),
                icon: Icon(Icons.add),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                "Tanda Tangan Muzakki",
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: canvasSize.height,
                width: canvasSize.width,
                child: Listener(
                  onPointerDown: (details) {
                    setState(() {
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final localPosition =
                          renderBox.globalToLocal(details.position);
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
                  onPointerMove: (details) {
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
                  onPointerUp: (details) {
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
                        painter:
                            SignaturePainter(paintingPoints: paintingPoints),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  spacing: 15,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          clearSign();
                        },
                        label: Text("Clear"),
                        icon: Icon(Icons.save),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await saveToFile(
                              customPath:
                                  "${Directory.current.path}/Signatures/$groupName.png");
                        },
                        label: Text("Save Sign To File"),
                        icon: Icon(Icons.save),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void clearSign() {
    setState(() {
      paintingPoints.clear();
    });
  }

  void onChange() {
    saved = false;
  }

  String generateRandomString(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random.secure();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  Future<void> saveAndPrintReceipt() async {
    await saveToFile(
        customPath: "${Directory.current.path}/Signatures//$groupName.png");

    List<MuzakkiInputData> muzakkiInputData = [];
    for (int i = 0; i < muzakkiEntry.length; i++) {
      muzakkiInputData.add(muzakkiEntry[i].muzakkiInputData);
    }

    if (saved == false) {
      var keysToDelete = [];
      var muzakkiMapData = muzakkiData.toMap();
      muzakkiMapData.forEach((k, v) {
        if (v.group == groupName) {
          keysToDelete.add(k);
        }
      });
      await muzakkiData.deleteAll(keysToDelete);

      for (var data in muzakkiInputData) {
        // print(
        //     "Name: ${data.name}\nType: ${data.zakatType}\nAmount: ${data.amount}");
        data.group = groupName;
        muzakkiData.add(data);
      }

      setState(() {
        saved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Muzakki baru telah dimasukkan ke dalam list"),
        ),
      );
    }

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Printing(
              muzakkiData: muzakkiInputData,
            );
          },
        ),
      );
    }
  }

  Future<void> removeEntry(int index) async {
    // Remove the item from the list
    setState(() {
      // var removedMuzakkiDataController =
      muzakkiEntry.removeAt(index);
      // removedMuzakkiDataController.nameFieldController.dispose();
      // removedMuzakkiDataController.zakatTypeFieldController.dispose();
      // removedMuzakkiDataController.amountFieldController.dispose();
    });
  }

  Future<void> saveToFile({String customPath = ""}) async {
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
    }
  }

  Future<void> openFileExplorer() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'sign.png',
    );

    if (outputFile != null) {
      await saveToFile(customPath: outputFile);
    }
  }
}
