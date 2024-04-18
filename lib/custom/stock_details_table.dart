import 'package:finobird/custom/shimmer_skelton.dart';
import 'package:flutter/material.dart';

import '../models/company/detailed_ticker_info.dart';
import '../constants/styles.dart';

class StockDetailsTable extends StatelessWidget {
  const StockDetailsTable({
    super.key,
    required this.details,
  });

  final SummaryDetail details;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text("Stock Details"),
        ),
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Market Capitalization",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    details.marketCap.toString(),
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Volume",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    details.volume.toString(),
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Day High",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    "${details.dayHigh} ${details.currency}",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Day Low",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    "${details.dayLow} ${details.currency}",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "52 Week High",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    "${details.fiftyTwoWeekHigh} ${details.currency}",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "52 Week Low",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    "${details.fiftyTwoWeekLow} ${details.currency}",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "52 Week Average",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    "${details.fiftyDayAverage} ${details.currency}",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dividend Rate",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    "${details.dividendRate} ${details.currency}",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trailing P/E",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    "${details.trailingPE}",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payout Ratio",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  Text(
                    "${details.payoutRatio}",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StockDetailsLoding extends StatelessWidget {
  const StockDetailsLoding({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text("Stock Details"),
        ),
      ],
      rows: [
        for (int i = 0; i < 6; i++)
          DataRow(
            cells: [
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeleton(
                      borderRadius: 0,
                      width: 140,
                      height: 20,
                    ),
                    Skeleton(
                      borderRadius: 0,
                      width: 140,
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
