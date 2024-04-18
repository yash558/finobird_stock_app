import 'package:finobird/repository/chat_repo.dart';
import 'package:finobird/repository/community_repo.dart';
import 'package:finobird/repository/company_repo.dart';
import 'package:finobird/screens/chat/chat_screen.dart';
import 'package:finobird/screens/watchlists/company_feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

import '../../custom/company_asset_profile.dart';
import '../../custom/company_details_table.dart';
import '../../custom/line_chart.dart';
import '../../custom/shimmer_skelton.dart';
import '../../custom/stock_details_table.dart';
import '../../models/company/company_model.dart';
import '../../constants/styles.dart';

class CompanyDetails extends StatelessWidget {
  CompanyDetails({
    Key? key,
    required this.ticker,
    required this.companyDetails,
  }) : super(key: key);

  final Company companyDetails;
  final String ticker;
  final CompanyRepo company = Get.put(CompanyRepo());
  final ChatRepo chats = Get.put(ChatRepo());
  final CommunitiesRepo repo = Get.put(CommunitiesRepo());

  @override
  Widget build(BuildContext context) {
    company.detailedTickerInfo(ticker);
    company.getAssetProfile(ticker);
    company.chart(ticker, "5y", "1mo");
    print(companyDetails);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4AB5E5),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          companyDetails.name ?? "",
          textScaleFactor: 1,
          style: Styles.text.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await repo.getCommunityDetails(
                companyDetails.communityId!,
              );
              Get.to(
                () => ChatScreen(
                  members: "",
                  title: companyDetails.name!,
                  isJoined: chats.chats.value.communities!.chats!.any(
                    (element) => element.id == repo.communityProfile.value.id,
                  ),
                  chatId: repo.communityProfile.value.chatId!,
                  communityId: repo.communityProfile.value.id!,
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.bubble_left_bubble_right_fill,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(
                () => CompanyFeeds(
                  companyName: companyDetails.name!,
                  ticker: ticker,
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.collections_solid,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LinkPreviewGenerator(
              link: companyDetails.website ?? "", 
              linkPreviewStyle: LinkPreviewStyle.large,
              removeElevation: true,
              showDomain: false,
              showBody: false,
              showTitle: false,
              graphicFit: BoxFit.contain,
              onTap: () {},
              placeholderWidget: Skeleton(
                borderRadius: 12,
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
              ),
            ),
            CompanyDetailsTable(companyDetails: companyDetails),
            Obx(
              () => company.isdetailedTickerInfoLoading.value
                  ? const StockDetailsLoding()
                  : (company.detailedInfo != null &&
                          company.detailedInfo!.value.summaryDetail != null)
                      ? StockDetailsTable(
                          details: company.detailedInfo!.value.summaryDetail!,
                        )
                      : Container(),
            ),
            Obx(
              () => company.ischartLoading.value
                  ? const LineChartLoading()
                  : LineChart(
                      chartData: company.chartData.value,
                    ),
            ),
            Obx(
              () => company.isgetAssetProfileLoading.value
                  ? const CompanyAssetProfileTableLoading()
                  : company.assetProfile.value.assetProfile != null
                      ? CompanyAssetProfileTable(
                          assetProfile:
                              company.assetProfile.value.assetProfile!,
                        )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
