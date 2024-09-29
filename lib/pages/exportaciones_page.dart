import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:syncfusion_officechart/officechart.dart';

class ExportacionesPage extends StatelessWidget {
  List<Map<String, dynamic>> partidosList = [
    {
      "id": "1234654",
      "partido": "Peru juntos",
      "representante": "Jhonny Gallegos",
      "votos": 10,
    },
    {
      "id": "9687984s",
      "partido": "Peru",
      "representante": "Matias Mengoa",
      "votos": 20,
    },
    {
      "id": "89751",
      "partido": "Paz Peru",
      "representante": "Lia Rivas",
      "votos": 50,
    },
    {
      "id": "9879163a",
      "partido": "Partido Peru",
      "representante": "Luahana Martinez",
      "votos": 98,
    }
  ];

  Future exportPDF() async {
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

  Future exportExcel() async {
    final workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("Nombre");
    sheet.getRangeByIndex(1, 2).setText("Apellido");
    sheet.getRangeByIndex(1, 3).setText("Edad");
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    QuerySnapshot userCollection = await userReference.get();

    List<QueryDocumentSnapshot> docs = userCollection.docs;

    int row = 2;

    List.generate(docs.length, (index) {
      sheet.getRangeByIndex(row, 1).setText(docs[index]["name"]);
      sheet.getRangeByIndex(row, 2).setText(docs[index]["lastName"]);
      sheet.getRangeByIndex(row, 3).setText(docs[index]["age"].toString());
      row++;
    });

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = "$path/miExcel.xlsx";
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);

    OpenFile.open(fileName);
  }

  Future exportExcelCharts() async {
    excel.Workbook workbook = excel.Workbook();
    excel.Worksheet sheet1 = workbook.worksheets.addWithName("CHART");

    //ENCABEZADO DE LA TABLA
    sheet1.enableSheetCalculations();
    sheet1.getRangeByName("A1").setText("id");
    sheet1.getRangeByIndex(1, 2).setText("Partido político");
    sheet1.getRangeByIndex(1, 3).setText("Representante");
    sheet1.getRangeByIndex(1, 4).setText("Votos");

    //Estilos
    sheet1.getRangeByIndex(1, 1).columnWidth = 15;
    sheet1.getRangeByIndex(1, 2).columnWidth = 20;
    sheet1.getRangeByIndex(1, 3).columnWidth = 25;
    sheet1.getRangeByIndex(1, 4).columnWidth = 10;

    sheet1.getRangeByName('A1:A18').rowHeight = 22;

    final excel.Style style1 = workbook.styles.add("Style1");
    style1.backColor = '#4CC2FF';
    style1.vAlign = excel.VAlignType.center;
    style1.hAlign = excel.HAlignType.center;
    style1.bold = true;

    final excel.Style style2 = workbook.styles.add("Style2");
    style2.vAlign = excel.VAlignType.center;
    style2.bold = true;

    int row = 2;

    sheet1.getRangeByName('A1:D1').cellStyle = style1;
    partidosList.forEach((element) {
      sheet1.getRangeByIndex(row, 1).setText(element["id"]);
      sheet1.getRangeByIndex(row, 2).setText(element["partido"]);
      sheet1.getRangeByIndex(row, 3).setText(element["representante"]);
      sheet1.getRangeByIndex(row, 4).setNumber(element["votos"].toDouble());
      row++;
    });

    sheet1.getRangeByIndex(row, 3).setText("TOTAL");
    sheet1.getRangeByIndex(row, 4).setFormula('=SUM(D2:D${row - 1})');

    //CREAR GRÁFICO
    final ChartCollection chartCollection = ChartCollection(sheet1);

    final Chart chart = chartCollection.add();
    chart.chartType = ExcelChartType.pie;
    chart.dataRange = sheet1.getRangeByName('C2:D${row - 1}');
    chart.isSeriesInRows = false;
    chart.chartTitle = "RESUMEN DE VOTOS";
    sheet1.charts = chartCollection;

    //GUARDAR  ARCHIVO
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    String path = (await getApplicationSupportDirectory()).path;
    String fileName = '$path/excelChart.xlsx';

    File file = File(fileName);
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
              ElevatedButton(
                onPressed: () {
                  exportExcelCharts();
                },
                child: Text("Exportar a excel con gráficos"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
