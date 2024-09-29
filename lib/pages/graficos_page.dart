import 'dart:math';

import 'package:firebaseconn3/models/data_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficosPage extends StatelessWidget {
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

  Widget _graph() {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 300,
                  child: _graph(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
