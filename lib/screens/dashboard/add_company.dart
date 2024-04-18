import 'dart:developer';

import 'package:finobird/models/company/search_company.dart';
import 'package:finobird/repository/company_repo.dart';
import 'package:finobird/screens/dashboard/add_to_watchlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

import '../../custom/custom_elevated_button.dart';
import '../../custom/shimmer_skelton.dart';
import '../../repository/watchlist_repo.dart';
import '../../constants/styles.dart';

class AddWatchlistCompany extends StatefulWidget {
  const AddWatchlistCompany({
    super.key,
    required this.isFromWatchlist,
    this.companies,
    this.id,
    this.name,
  });
  final bool isFromWatchlist;
  final List? companies;
  final int? id;
  final String? name;

  @override
  State<AddWatchlistCompany> createState() => _AddWatchlistCompanyState();
}

class _AddWatchlistCompanyState extends State<AddWatchlistCompany> {
  CompanyRepo companies = Get.put(CompanyRepo());
  var controller = TextEditingController();
  RxList selectedCompanies = [].obs;
  RxList<Result> searchResults = <Result>[].obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () async {
      await companies.search("", 200, 0);
      searchResults.addAll(companies.tickerSearch.value.result ?? []);
      if (widget.isFromWatchlist) {
        log("is from watchlist");
        for (var element in widget.companies!) {
          log(element.toJson().toString());
          selectedCompanies.add(element.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() async {
      await companies.search(controller.text.toLowerCase(), 50, 0);
      searchResults.clear();
      searchResults.addAll(companies.tickerSearch.value.result ?? []);
      // for (var element in companies.tickerSearch.value.result!) {
      //   if (element.name!
      //       .toLowerCase()
      //       .contains(controller.text.toLowerCase())) {

      //     searchResults.add(element);
      //   }
      // }
    });

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF4AB5E5),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Select Companies',
            textScaleFactor: 1,
            style: Styles.text.copyWith(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                searchResults.sort((a, b) => a.name!.compareTo(b.name!));
                for (var element in searchResults) {
                  log(element.name!);
                }
              },
              icon: const Icon(LineIcons.sortAlphabeticalDown),
            ),
            IconButton(
              onPressed: () {
                searchResults.sort((a, b) => b.name!.compareTo(a.name!));
                for (var element in searchResults) {
                  log(element.name!);
                }
              },
              icon: const Icon(LineIcons.sortAlphabeticalUp),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: controller,
                placeholder: "Search",
                style: Styles.text,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (!selectedCompanies
                          .contains(searchResults[index].id)) {
                        selectedCompanies.addIf(
                          !selectedCompanies.contains(searchResults[index].id),
                          searchResults[index].id,
                        );
                      } else {
                        selectedCompanies.remove(searchResults[index].id);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF4AB5E5),
                            child: selectedCompanies.contains(
                              searchResults[index].id,
                            )
                                ? const Icon(Icons.check)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: LinkPreviewGenerator(
                                      link: searchResults[index].website ?? "",
                                      linkPreviewStyle: LinkPreviewStyle.large,
                                      removeElevation: true,
                                      showDomain: false,
                                      showBody: false,
                                      showTitle: false,
                                      graphicFit: BoxFit.contain,
                                      onTap: () {
                                        if (!selectedCompanies.contains(
                                            searchResults[index].id)) {
                                          selectedCompanies.addIf(
                                            !selectedCompanies.contains(
                                                searchResults[index].id),
                                            searchResults[index].id,
                                          );
                                        } else {
                                          selectedCompanies
                                              .remove(searchResults[index].id);
                                        }
                                      },
                                      placeholderWidget: Skeleton(
                                        borderRadius: 12,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                          ),
                          // FutureBuilder(
                          //   future: companies
                          //       .fetchLogoUrl(searchResults[index].website),
                          //   builder: (context, snapshot) => CircleAvatar(
                          //     backgroundColor: Color(0xFF4AB5E5),
                          //     child: Stack(
                          //       fit: StackFit.expand,
                          //       children: [
                          //         snapshot.data != null
                          //             ? CachedNetworkImage(
                          //                 imageUrl: snapshot.data!,
                          //                 placeholder: (context, url) =>
                          //                     const CircularProgressIndicator(),
                          //                 errorWidget: (context, url, error) =>
                          //                     const SizedBox(),
                          //               )
                          //             : const SizedBox(),
                          //         selectedCompanies.contains(
                          //           searchResults[index].id,
                          //         )
                          //             ? const Icon(Icons.check)
                          //             : const SizedBox(),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                searchResults[index].name!,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
            // : Expanded(
            //     child: ListView.builder(
            //       itemCount: 5,
            //       itemBuilder: (context, index) {
            //         return const CompanyCardSkelton();
            //       },
            //     ),
            //   )
          ],
        ),
        floatingActionButton: Badge.count(
          count: selectedCompanies.length,
          largeSize: 20,
          isLabelVisible: selectedCompanies.isNotEmpty,
          backgroundColor: const Color(0xFF4AB5E5),
          child: FloatingActionButton(
            onPressed: () {
              if (selectedCompanies.isNotEmpty) {
                if (!widget.isFromWatchlist) {
                  Get.to(
                    () => AddToWatchlist(
                      companies: selectedCompanies,
                      isFoods: false,
                    ),
                  );
                } else {
                  var watchlists = Get.put(WatchlistRepo());
                  Get.defaultDialog(
                    title: "Info",
                    titleStyle: Styles.semiBold,
                    content: Column(
                      children: [
                        Text(
                          "Do you want to add your watchlist?",
                          textAlign: TextAlign.center,
                          style: Styles.text,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomElevatedButton(
                              onPressed: () {
                                watchlists.updateWatchlist(
                                  selectedCompanies,
                                  widget.id!,
                                  widget.name!,
                                );
                              },
                              child: const Center(
                                child: Text("Yes"),
                              ),
                            ),
                            CustomElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Center(
                                child: Text("No"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              } else {
                Fluttertoast.showToast(
                  msg: "Select some companies before proceeding",
                );
              }
            },
            backgroundColor: const Color(0xFF4AB5E5),
            child: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
