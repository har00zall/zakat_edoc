import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
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

  pw.Column receipt() {
    return pw.Column(
      children: [
        pw.Center(
          child: pw.Text(
            "Bukti Pembayaran Zakat",
          ),
        ),
        pw.Divider(height: 2.5, thickness: 2),
        pw.Column(
          children: List.generate(
            widget.muzakkiData.length,
            (index) {
              MuzakkiInputData muzakkiData = widget.muzakkiData[index];
              return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
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
        )
      ],
    );
  }
}
