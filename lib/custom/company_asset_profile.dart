import 'package:finobird/custom/shimmer_skelton.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../models/company/company_asset_profile.dart';
import '../constants/styles.dart';

class CompanyAssetProfileTable extends StatelessWidget {
  const CompanyAssetProfileTable({
    super.key,
    required this.assetProfile,
  });
  final AssetProfile assetProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(
              label: Text("Asset Profile"),
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
                        "Employees",
                        textScaleFactor: 1,
                        style: Styles.text,
                      ),
                      Text(
                        (assetProfile.fullTimeEmployees ?? "N/A").toString(),
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
                        "Industry",
                        textScaleFactor: 1,
                        style: Styles.text,
                      ),
                      Text(
                        assetProfile.industry.toString(),
                        textScaleFactor: 1,
                        style: Styles.text,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              "Business Summary",
              style: Styles.semiBold.copyWith(fontSize: 15),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ReadMoreText(
                assetProfile.longBusinessSummary!,
                trimLines: 4,
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: Styles.semiBold.copyWith(fontSize: 12),
                lessStyle: Styles.semiBold.copyWith(fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CompanyAssetProfileTableLoading extends StatelessWidget {
  const CompanyAssetProfileTableLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text("Asset Profile"),
        ),
      ],
      rows: [
        for (int i = 0; i < 2; i++)
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
