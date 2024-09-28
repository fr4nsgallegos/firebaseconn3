import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

class ExportacionesPage extends StatelessWidget {
  exportPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [
                pw.Text(
                  "Hola",
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#2775E4"),
                  ),
                ),
                pw.Text(
                  "Hola",
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#2775E4"),
                  ),
                ),
                pw.Text(
                  "Hola",
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#2775E4"),
                  ),
                ),
                pw.Text(
                  "Hola",
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#2775E4"),
                  ),
                ),
                pw.Text(
                  "Hola",
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#2775E4"),
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );
    Uint8List bytes = await pdf.save();
    print(bytes);

    Directory directory = await getApplicationSupportDirectory();
    print(directory);

    String fileName = "${directory.path}/reporte.pdf";

    File pdfFile = File(fileName);
    await pdfFile.writeAsBytes(bytes, flush: true);

    OpenFile.open(fileName);
  }

  exportExcel() async {
    final workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("HOLAAAAAAAA");
    sheet.getRangeByIndex(2, 1).setText("HOLA 2");

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = "$path/miExcel.xlsx";
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);

    OpenFile.open(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  exportPDF();
                },
                child: Text("Exportar a pdf"),
              ),
              ElevatedButton(
                onPressed: () {
                  exportExcel();
                },
                child: Text("Exportar a excel"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
