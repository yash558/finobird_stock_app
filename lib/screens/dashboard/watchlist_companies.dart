// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/repository/watchlist_repo.dart';
import 'package:finobird/screens/dashboard/add_company.dart';
import 'package:finobird/screens/watchlists/company_feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

import '../../custom/shimmer_skelton.dart';
import '../../models/watchlist/get_watchlists.dart';
import '../../repository/chat_repo.dart';
import '../../repository/community_repo.dart';
import '../../constants/styles.dart';
import '../chat/chat_screen.dart';
import '../feeds/company.dart';

class WatchlistCompanies extends StatefulWidget {
  const WatchlistCompanies({
    super.key,
    required this.id,
    required this.name,
    required this.companies,
  });
  final int id;
  final String name;
  final List<Companies> companies;

  @override
  State<WatchlistCompanies> createState() => _WatchlistCompaniesState();
}

class _WatchlistCompaniesState extends State<WatchlistCompanies> {
  RxBool isEditEnabled = false.obs;
  final ChatRepo chats = Get.put(ChatRepo());
  RxList<Companies> items = <Companies>[].obs;
  var controller = TextEditingController(),
      changeName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxList<Companies> searchResults = [...widget.companies].obs;
    controller.addListener(() {
      searchResults.clear();
      for (var element in widget.companies) {
        if (element.name!
            .toLowerCase()
            .contains(controller.text.toLowerCase())) {
          searchResults.add(element);
        }
      }
    });

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF4AB5E5),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: InkWell(
            onTap: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.noHeader,
                titleTextStyle: Styles.semiBold,
                body: CustomTextField(
                  controller: changeName,
                  text: "Name",
                  type: TextInputType.name,
                ),
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  if (changeName.text.isNotEmpty) {
                    var companies = List.generate(
                      widget.companies.length,
                      (index) => widget.companies[index].id,
                    );
                    log("\n\n\n\n$companies\n\n\n\n\n\n");
                    WatchlistRepo().updateWatchlist(
                      companies,
                      widget.id,
                      changeName.text,
                    );
                  } else {
                    Fluttertoast.showToast(msg: "Name cannot be empty");
                  }
                },
                btnOkColor: const Color(0xFF4AB5E5),
                descTextStyle: Styles.text,
                buttonsTextStyle: Styles.text,
              ).show();
            },
            child: Text(
              widget.name,
              textScaleFactor: 1,
              style: Styles.text.copyWith(color: Colors.white),
            ),
          ),
          actions: [
            Visibility(
              visible: !isEditEnabled.value,
              child: IconButton(
                onPressed: () {
                  searchResults.sort((a, b) => a.name!.compareTo(b.name!));
                  for (var element in searchResults) {
                    log(element.name!);
                  }
                },
                icon: const Icon(LineIcons.sortAlphabeticalDown),
              ),
            ),
            Visibility(
              visible: !isEditEnabled.value,
              child: IconButton(
                onPressed: () {
                  searchResults.sort((a, b) => b.name!.compareTo(a.name!));
                  for (var element in searchResults) {
                    log(element.name!);
                  }
                },
                icon: const Icon(LineIcons.sortAlphabeticalUp),
              ),
            ),
            Visibility(
              visible: !isEditEnabled.value,
              child: IconButton(
                onPressed: () {
                  isEditEnabled.value = !isEditEnabled.value;
                },
                icon: const Icon(LineIcons.edit),
              ),
            ),
            Visibility(
              visible: isEditEnabled.value,
              child: IconButton(
                onPressed: () {
                  if (items.isNotEmpty) {
                    var myCompanies = [...widget.companies];
                    for (var element in items) {
                      myCompanies.remove(element);
                    }

                    if (myCompanies.isEmpty) {
                      Fluttertoast.showToast(
                          msg:
                              "Atleast one company must be present in watchlist!");
                      return;
                    }
                    var companies = List.generate(
                      myCompanies.length,
                      (index) => myCompanies[index].id,
                    );
                    log("\n\n\n\n$companies\n\n\n\n\n\n");
                    WatchlistRepo().updateWatchlist(
                      companies,
                      widget.id,
                      widget.name,
                    );
                    isEditEnabled.value = false;
                  } else {
                    isEditEnabled.value = false;
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: controller,
                placeholder: "Search Companies",
                style: Styles.text,
              ),
            ),
            searchResults.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            if (isEditEnabled.value) {
                              if (items.contains(searchResults[index])) {
                                items.remove(searchResults[index]);
                                setState(() {});
                              } else {
                                items.add(searchResults[index]);
                                setState(() {});
                              }
                            } else {
                              CommunitiesRepo repo = Get.put(CommunitiesRepo());
                              await repo.getCommunityDetails(
                                searchResults[index].communityId!,
                              );
                              print(repo.communityProfile.value.company);
                              Get.to(
                                () => CompanyDetails(
                                  ticker: searchResults[index].ticker!,
                                  companyDetails:
                                      repo.communityProfile.value.company!,
                                ),
                              );
                            }
                          },
                          title: Text(
                            searchResults[index].name!,
                            style: Styles.text,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF4AB5E5),
                            child: items.contains(searchResults[index]) &&
                                    isEditEnabled.value
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
                                      onTap: () {},
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
                          trailing: Wrap(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  CommunitiesRepo repo =
                                      Get.put(CommunitiesRepo());
                                  await repo.getCommunityDetails(
                                    searchResults[index].communityId!,
                                  );
                                  Get.to(
                                    () => ChatScreen(
                                      members: "",
                                      title: searchResults[index].name!,
                                      isJoined: chats
                                          .chats.value.communities!.chats!
                                          .any((element) =>
                                              element.id ==
                                              repo.communityProfile.value.id),
                                      chatId:
                                          repo.communityProfile.value.chatId!,
                                      communityId:
                                          repo.communityProfile.value.id!,
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  CupertinoIcons.bubble_left_bubble_right_fill,
                                  color: Color(0xFF4AB5E5),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.to(
                                    () => CompanyFeeds(
                                      companyName: searchResults[index].name!,
                                      ticker: searchResults[index].ticker!,
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  CupertinoIcons.collections_solid,
                                  color: Color(0xFF4AB5E5),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Text(
                        "No companies",
                        style: Styles.text,
                      ),
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF4AB5E5),
          onPressed: () {
            Get.to(() => AddWatchlistCompany(
                  isFromWatchlist: true,
                  companies: widget.companies,
                  name: widget.name,
                  id: widget.id,
                ));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
