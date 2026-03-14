import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/database/muzakki_input_data.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;

class Printing extends StatefulWidget {
  const Printing({super.key, required this.muzakkiData});

  final List<MuzakkiInputData> muzakkiData;

  @override
  State<Printing> createState() => _PrintingState();
}

class _PrintingState extends State<Printing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Print Preview"),
      ),
      body: PdfPreview(
        previewPageMargin: EdgeInsets.all(0),
        enableScrollToPage: true,
        build: (format) => generatePDF(format, widget.muzakkiData),
        onPrinted: (context) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Receipt Has Been Printed"),
              action: SnackBarAction(
                label: "Back To Dashboard",
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName("/"),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Uint8List> generatePDF(
      PdfPageFormat format, List<MuzakkiInputData> muzakkiData) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    final pathToSignature = await getSignatureFile(widget.muzakkiData[0].group);
    final groupSign = pw.MemoryImage(File(pathToSignature).readAsBytesSync());

    final authority = authorityData.getAt(0);
    final ketuaAmilSign =
        pw.MemoryImage(File(authority!.ketuaAmilSign).readAsBytesSync());
    final sekretarisSign =
        pw.MemoryImage(File(authority.sekretarisSign).readAsBytesSync());

    var duplicateData = pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: receipt(groupSign, ketuaAmilSign, sekretarisSign),
        ),
        pw.Text(
          "*Bagian ini disimpan oleh panitia",
          style: pw.TextStyle(
            color: PdfColors.red,
          ),
        ),
      ],
    );

    var page = pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: receipt(groupSign, ketuaAmilSign, sekretarisSign),
            ),
            pw.SizedBox(
              height: 5,
            ),
            muzakkiData.length <= 6 ? duplicateData : pw.SizedBox(),
          ],
        );
      },
    );

    pdf.addPage(
      page,
      index: 0,
    );

    if (muzakkiData.length > 6) {
      var duplicatePage = pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              duplicateData,
            ],
          );
        },
      );

      pdf.addPage(
        duplicatePage,
        index: 1,
      );
    }

    return pdf.save();
  }

  pw.Container receipt(pw.MemoryImage groupSignParam,
      pw.MemoryImage ketuaAmilSignParam, pw.MemoryImage sekretarisSignParam) {
    double totalRP = 0;
    double totalKg = 0;

    for (var v in widget.muzakkiData) {
      double currentAmount = double.parse(v.amount);

      if (v.zakatType == ZakatType.uang) {
        totalRP += currentAmount;
      } else {
        totalKg += currentAmount;
      }
    }

    final groupSign = groupSignParam;
    // "${Directory.current.path}/Signatures/${widget.muzakkiData[0].group}.png")
    //.readAsBytesSync();

    final ketuaAmilSign = ketuaAmilSignParam;
    final sekretarisSign = sekretarisSignParam;

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      padding: pw.EdgeInsets.all(15),
      child: pw.Column(
        children: [
          pw.Center(
            child: pw.Text(
              style: pw.TextStyle(
                font: pw.Font.timesBold(),
              ),
              textAlign: pw.TextAlign.center,
              "PANITIA (AMIL) ZAKAT FITRAH\nBKM MASJID MA'SHUM THO'AT RT 15 SIDOMULYO BENGKULU 1446 H/2025 M",
            ),
          ),
          pw.SizedBox(
            height: 10,
          ),
          pw.Text("MUZAKKI/ORANG PEMBAYAR ZAKAT:"),
          pw.SizedBox(
            height: 10,
          ),
          pw.Column(
            children: List.generate(
              widget.muzakkiData.length,
              (index) {
                MuzakkiInputData muzakkiData = widget.muzakkiData[index];
                double zakatAmount = double.tryParse(muzakkiData.amount) ?? 0;
                return pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text("${index + 1}. "),
                    ),
                    pw.Expanded(
                      flex: 5,
                      child: pw.Text(muzakkiData.name),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(muzakkiData.zakatType == ZakatType.uang
                          ? 'Uang'
                          : 'Beras'),
                    ),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text(
                          "${muzakkiData.zakatType == ZakatType.uang ? 'Rp.' : ''} ${NumberFormat('#,##0.00').format(zakatAmount)} ${muzakkiData.zakatType == ZakatType.beras ? 'Kg' : ''}"),
                    ),
                    // pw.Expanded(
                    //   flex: 2,
                    //   child: pw.OverflowBox(
                    //     maxHeight: 25,
                    //     child: pw.Image(groupSign),
                    //   ),
                    // ),
                  ],
                );
              },
            ),
          ),
          pw.SizedBox(
            height: 15,
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              pw.Text(
                "Total Rp: ${NumberFormat('#,##0.00').format(totalRP)}",
                style: pw.TextStyle(
                  font: pw.Font.helveticaBold(),
                ),
              ),
              pw.Text(
                "Total Kg: ${NumberFormat('#,##0.00').format(totalKg)}",
                style: pw.TextStyle(
                  font: pw.Font.helveticaBold(),
                ),
              ),
            ],
          ),
          pw.SizedBox(
            height: 15,
          ),
          pw.Text("Lafadz Niat Menunaikan Zakat Fitrah:"),
          pw.SizedBox(
            height: 5,
          ),
          pw.Text(
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontStyle: pw.FontStyle.italic,
                fontSize: 10,
              ),
              "Arab-Latin: Nawaytu an-ukhrija zakaatal-fitri 'an-ni wa 'an-jami'i ma yalzimuniy nafaqatuhum syar'an fardhan lillahi ta'ala"),
          pw.SizedBox(
            height: 15,
          ),
          pw.Text(
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 10,
              ),
              "Artinya: Sengaja aku mengeluarkan zakat fitrah untuk diriku dan seluruh orang yang nafkahnya menjadi tanggunganku fardhu karena Allah ta'ala"),
          pw.SizedBox(
            height: 15,
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              pw.Column(
                children: [
                  pw.Text("Muzakki,"),
                  pw.SizedBox(
                    height: 50,
                    child: pw.Image(groupSign), // pw.Image(ketuaBKMSign),
                  ),
                  pw.Text(widget.muzakkiData[0].name
                      // authorityData.isEmpty
                      //   ? "_____________"
                      //   : authorityData.getAt(0)?.ketuaBKM ?? "_____________"
                      ),
                ],
              ),
              pw.Column(
                children: [
                  pw.Text("Ketua 'Amil,"),
                  pw.SizedBox(
                    height: 50,
                    child: pw.Image(ketuaAmilSign),
                  ),
                  pw.Text(authorityData.isEmpty
                      ? "_____________"
                      : authorityData.getAt(0)?.ketuaAmil ?? "_____________")
                ],
              ),
              pw.Column(
                children: [
                  pw.Text("Sekretaris,"),
                  pw.SizedBox(
                    height: 50,
                    child: pw.Image(sekretarisSign),
                  ),
                  pw.Text(authorityData.isEmpty
                      ? "_____________"
                      : authorityData.getAt(0)?.sekretaris ?? "_____________")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> getSignatureFile(String groupName) async {
    // 1. Get the correct directory for Android/iOS
    final directory = await getApplicationDocumentsDirectory();

    // 2. Create a sub-folder if it doesn't exist
    final folderPath = Directory('${directory.path}/Signatures');
    if (!folderPath.existsSync()) {
      await folderPath.create(recursive: true);
    }

    // 3. Construct the full path cleanly
    // Result: /data/user/0/com.example.app/app_flutter/Signatures/YourGroupName.png
    final filePath = p.join(folderPath.path, '$groupName.png');
    //print(filePath);
    return filePath;
    //return File(filePath);
  }
}
