import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zakat_edoc/database/muzakki_input_data.dart';

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
  List<MuzakkiInputController> muzakkiEntry = List.empty(growable: true);

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
              onPressed: () {
                setState(
                  () {
                    muzakkiEntry.add(
                      MuzakkiInputController(
                        muzakkiInputData: MuzakkiInputData(),
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
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(
            Duration(milliseconds: 100),
          ),
          builder: (context, snapshot) {
            return ListView.builder(
              // header: Padding(
              //   padding: EdgeInsets.all(15),
              //   child: Row(
              //     spacing: 15,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Nama Muzakki",
              //         style: GoogleFonts.rubik(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       Text(
              //         "Tipe Zakat",
              //         style: GoogleFonts.rubik(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       Text(
              //         "Jumlah",
              //         style: GoogleFonts.rubik(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              itemCount: muzakkiEntry.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  key: ValueKey(muzakkiEntry[index]),
                  leading: Text(
                    "${index + 1}",
                    style: GoogleFonts.rubik(fontSize: 14),
                  ),
                  tileColor: index.isOdd ? Colors.black12 : Colors.white,
                  trailing: IconButton.outlined(
                    onPressed: () {
                      removeEntry(index);
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
                                muzakkiEntry[index].muzakkiInputData.zakatType =
                                    value!;
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
                                muzakkiEntry[index].muzakkiInputData.amount =
                                    value;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              //onReorder: (int from, int to) {},
            );
          },
        ),
      ),
    );
  }

  void removeEntry(int index) {
    // Remove the item from the list
    Future.microtask(() {
      setState(() {
        var removedMuzakkiDataController = muzakkiEntry.removeAt(index);
        removedMuzakkiDataController.nameFieldController.dispose();
        removedMuzakkiDataController.zakatTypeFieldController.dispose();
        removedMuzakkiDataController.amountFieldController.dispose();
      });
    });
  }
}
