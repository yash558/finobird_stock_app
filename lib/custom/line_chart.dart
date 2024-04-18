import 'package:finobird/custom/shimmer_skelton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/company/stock_chart.dart';

class LineChart extends StatelessWidget {
  const LineChart({super.key, required this.chartData});
  final StockChart chartData;

  @override
  Widget build(BuildContext context) {
    var quotes = chartData.quotes ?? [];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        enableAxisAnimation: true,
        series: <ChartSeries>[
          CandleSeries<Quotes?, DateTime>(
            dataSource: quotes,
            xAxisName: "Time",
            yAxisName: "Price",
            name: "Stock Price",
            xValueMapper: (quote, date) => DateTime.parse(quote!.date!),
            lowValueMapper: (quote, _) => quote!.low,
            highValueMapper: (quote, _) => quote!.high,
            openValueMapper: (quote, _) => quote!.open,
            closeValueMapper: (quote, _) => quote!.close,
          )
        ],
      ),
    );
  }
}

class LineChartLoading extends StatelessWidget {
  const LineChartLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
      child: Skeleton(
        borderRadius: 10,
        height: Get.height * .4,
        width: Get.width,
      ),
    );
  }
}
