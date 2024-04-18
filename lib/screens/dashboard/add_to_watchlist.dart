import 'dart:developer';

import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/repository/watchlist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../repository/feed_repo.dart';
import '../../constants/styles.dart';

class AddToWatchlist extends StatelessWidget {
  const AddToWatchlist({
    super.key,
    required this.companies,
    required  this.isFoods,
     this.companyId


  });
  final List companies;
  final bool isFoods;
  final int? companyId;


  @override
  Widget build(BuildContext context) {
    var watchlists = Get.put(WatchlistRepo());
    var name = TextEditingController();
    var feed = Get.put(FeedRepo());
    print('dfgnkfgk  '+companies.toString());
    watchlists.getWatchlists(100, false);
    feed.getAnnouncements();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF4AB5E5),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Add to Watchlist',
            textScaleFactor: 1,
            style: Styles.text.copyWith(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: "Select Watchlist",
              ),
              Tab(
                text: "Create Watchlist",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            if (watchlists.myWatchlists.value.watchlists.isEmpty)
              Center(
                child: Text(
                  "No Watchlists Available",
                  style: Styles.text,
                ),
              )
            else
              ListView.builder(
                itemCount: watchlists.myWatchlists.value.watchlists.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.defaultDialog(
                        contentPadding:    EdgeInsets.only(top: 15,left: 15,right: 15),
                        title: "Info",
                        titleStyle: Styles.semiBold,

                        content: Column(
                          children: [
                            Text(
                              "Do you want to add the companies in ${watchlists.myWatchlists.value.watchlists[index].name}",
                              textAlign: TextAlign.center,
                              style: Styles.text,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomElevatedButton(
                                  onPressed: () {
                                    // var companiesWithId = [];
                                    // for (var element in watchlists.myWatchlists
                                    //     .value.watchlists[index].companies!) {
                                    //   companiesWithId.add(element.id);
                                    // }
                                    // companiesWithId.addAll(companies);

                             if(isFoods){
                               print('isFoods screen');
                               var companiesWithId = [];
                                 companiesWithId.add(companyId);
                               if(watchlists.myWatchlists.value.watchlists.isNotEmpty){
                                 for(int i =0; i<watchlists.myWatchlists.value.watchlists.length; i++){
                                   if(watchlists.myWatchlists.value.watchlists[i].id ==  watchlists.myWatchlists.value
                                       .watchlists[index].id){
                                     for(int j =0; j<watchlists.myWatchlists.value.watchlists[i].companies!.length; j++){
                                       if(watchlists.myWatchlists.value.watchlists[i].companies!.isNotEmpty){
                                         companiesWithId.add(watchlists.myWatchlists.value.watchlists[i].companies![j].id);
                                       }
                                     }
                                   }
                                 }
                               }
                               watchlists.updateWatchlist(
                                 companiesWithId,
                                 watchlists.myWatchlists.value
                                     .watchlists[index].id!,
                                 watchlists.myWatchlists.value
                                     .watchlists[index].name!,
                               );

                             }else{
                               watchlists.updateWatchlist(
                                 companies,
                                 watchlists.myWatchlists.value
                                     .watchlists[index].id!,
                                 watchlists.myWatchlists.value
                                     .watchlists[index].name!,
                               );
                             }


                                  },
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Text("Add"),
                                    ),
                                  ),
                                ),
                                CustomElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Text("Cancel"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        watchlists.myWatchlists.value.watchlists[index].name!,
                        style: Styles.text,
                      ),
                    ),
                  );
                },
              ),
            Column(
              children: [
                CustomTextField(
                  controller: name,
                  text: "Watchlist Name",
                  hintText: "Enter the watchlist name",
                  type: TextInputType.name,
                  inputFormatters: [LengthLimitingTextInputFormatter(15)],
                ),
                const Spacer(),
                CustomElevatedButton(
                  onPressed: () {
                    if(isFoods){
                     var companiesWithId = [];
                     companiesWithId.add(companyId);
                      WatchlistRepo().createWatchlist(
                        companiesWithId,
                        name.text,
                      );
                    }else{
                      WatchlistRepo().createWatchlist(
                        companies,
                        name.text,
                      );
                    }

                  },
                  child: Center(
                    child: Text(
                      "Create And Add Companies",
                      style: Styles.text.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
