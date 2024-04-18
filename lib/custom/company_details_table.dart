import 'package:finobird/custom/shimmer_skelton.dart';
import 'package:finobird/custom/webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../models/company/company_model.dart';
import '../constants/styles.dart';

class CompanyDetailsTable extends StatelessWidget {
  const CompanyDetailsTable({
    super.key,
    required this.companyDetails,
  });

  final Company companyDetails;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      
      columns: const [
        DataColumn(
          label: Text("Company Details"),          
        ),        
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(
              Row(
                children: [
                  Text(
                    "Company Name",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      companyDetails.name!,
                      textScaleFactor: 1,
                      style: Styles.text,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                children: [
                  Text(
                    "Ticker",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      companyDetails.ticker!,
                      textScaleFactor: 1,
                      style: Styles.text,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                children: [
                  Text(
                    "Sector",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      companyDetails.sector!,
                      textScaleFactor: 1,
                      style: Styles.text,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                    "Country",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      companyDetails.country!,
                      textScaleFactor: 1,
                      style: Styles.text,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                    "Website",
                    textScaleFactor: 1,
                    style: Styles.text,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => Webview(url: companyDetails.website!));
                    },
                    child: const Icon(
                      LineIcons.globe,
                      color: Colors.blue,
                    ),
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

class CompanyDetailsTableLoding extends StatelessWidget {
  const CompanyDetailsTableLoding({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text("Company Details"),
        ),
      ],
      rows: [
        for (int i = 0; i < 4; i++)
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
