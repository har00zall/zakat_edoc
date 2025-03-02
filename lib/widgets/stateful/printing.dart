import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:zakat_edoc/data_route.dart';
import 'package:zakat_edoc/database/muzakki_input_data.dart';
import 'package:pdf/widgets.dart' as pw;

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
        build: (format) => generatePDF(format, widget.muzakkiData),
        onPrinted: (context) {
          for (var data in widget.muzakkiData) {
            // print(
            //     "Name: ${data.name}\nType: ${data.zakatType}\nAmount: ${data.amount}");
            muzakkiData.add(data);
          }
        },
      ),
    );
  }

  Future<Uint8List> generatePDF(
      PdfPageFormat format, List<MuzakkiInputData> muzakkiData) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              receipt(),
              pw.SizedBox(
                height: 50,
              ),
              receipt(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Container receipt() {
    late String totalRP = "0";
    late String totalKg = "0";

    for (var v in widget.muzakkiData) {
      double currentAmount = double.parse(v.amount);

      if (v.zakatType == ZakatType.uang) {
        double currentTotalRP = double.parse(totalRP);
        currentTotalRP += currentAmount;
        totalRP = currentTotalRP.toStringAsFixed(2);
      } else {
        double currentTotalKg = double.parse(totalKg);
        currentTotalKg += currentAmount;
        totalKg = currentTotalKg.toString();
      }
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      padding: pw.EdgeInsets.all(15),
      child: pw.Column(
        children: [
          pw.Center(
            child: pw.Text(
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
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("${index + 1}. "),
                    pw.Expanded(
                      child: pw.Text(muzakkiData.name),
                    ),
                    pw.Expanded(
                      child: pw.Text(muzakkiData.zakatType == ZakatType.uang
                          ? 'Uang'
                          : 'Beras'),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                          "${muzakkiData.zakatType == ZakatType.uang ? 'Rp.' : ''} ${muzakkiData.amount} ${muzakkiData.zakatType == ZakatType.beras ? 'Kg' : ''}"),
                    ),
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
              pw.Text("Total Rp: $totalRP"),
              pw.Text("Total Kg: $totalKg"),
            ],
          ),
          pw.Text("Lafadz Niat Menunaikan Zakat Fitrah:"),
          pw.SizedBox(
            height: 5,
          ),
          pw.Text(
              textAlign: pw.TextAlign.center,
              "Arab-Latin: Nawaytu an-ukhrija zakaatal-fitri 'an-ni wa 'an-jami'i ma yalzimuniy nafaqatuhum syar'an fardhan lillahi ta'ala"),
          pw.SizedBox(
            height: 5,
          ),
          pw.Text(
              textAlign: pw.TextAlign.center,
              "Artinya: Sengaja aku mengeluarkan zakat fitrah untuk diriku dan seluruh orang yang nafkahnya menjadi tanggunganku fardhu karena Allah ta'ala"),
          pw.SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
