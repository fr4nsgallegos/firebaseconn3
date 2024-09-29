import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebaseconn3/models/data_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GraficosPage extends StatefulWidget {
  @override
  State<GraficosPage> createState() => _GraficosPageState();
}

class _GraficosPageState extends State<GraficosPage> {
  bool showImageFromGraph = false;

  Uint8List imagen = Uint8List(8);

  GlobalKey globalKey = new GlobalKey();

  List<DataModel> _generateData(int max) {
    final random = Random();
    return List.generate(31, (index) {
      double valor = random.nextDouble() * max;
      // if (valor.isNaN || valor.isFinite) {
      //   valor = 0;
      // }
      return DataModel(
        date: DateTime(2024, 1, index + 1),
        valor: valor,
      );
    });
  }

  Widget _graph1() {
    final spots = _generateData(50).asMap().entries.map(
      (e) {
        double x = e.key.toDouble();
        double y = e.value.valor;

        // if (y.isNaN || y.isInfinite) {
        //   y = 0;
        // }
        return FlSpot(x, y);
      },
    ).toList();

    final spots2 = _generateData(300)
        .asMap()
        .entries
        .map(
          (e) => FlSpot(
            e.key.toDouble(),
            e.value.valor,
          ),
        )
        .toList();

    // spots.forEach((element) => print(element));
    // print(spots.length);

    return LineChart(
      LineChartData(
        minX: 0,
        minY: 0,
        // maxX: spots.length.toDouble(),
        // maxY: 60,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: Colors.red,
          ),
          LineChartBarData(
            spots: spots2,
            isCurved: true,
            color: Colors.green,
          ),
        ],
        titlesData: FlTitlesData(show: true),
        gridData: FlGridData(show: true),
      ),
    );
  }

  Widget _graph2() {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(
                barsSpace: 20,
                groupVertically: false,
                x: 1,
                barRods: [
                  BarChartRodData(
                      fromY: 0, toY: 15, color: Colors.red, width: 20),
                  BarChartRodData(
                      fromY: 0, toY: 100, color: Colors.black, width: 20),
                  BarChartRodData(
                      fromY: 0, toY: 150, color: Colors.cyan, width: 20),
                  BarChartRodData(
                      fromY: 0, toY: 200, color: Colors.yellow, width: 20),
                  BarChartRodData(
                      fromY: 0, toY: 75, color: Colors.pink, width: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> captureWidget() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage();

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    imagen = pngBytes;
    return imagen;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("GRÁFICO 1"),
                Container(
                  height: 300,
                  child: _graph1(),
                ),
                Divider(),
                Text("GRÁFICO 2"),
                Container(
                  height: 300,
                  child: _graph2(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    imagen = await captureWidget();
                    showImageFromGraph = true;
                    setState(() {});
                  },
                  child: Text("Convertir gráfico a imagen"),
                ),
                SizedBox(
                  height: 16,
                ),
                showImageFromGraph
                    ? Container(
                        padding: EdgeInsets.all(16),
                        width: 400,
                        height: 400,
                        child: Image.memory(
                          Uint8List.fromList(imagen),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
