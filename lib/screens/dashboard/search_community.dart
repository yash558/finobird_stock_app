import 'package:finobird/constants/colors.dart';
import 'package:finobird/constants/styles.dart';
import 'package:finobird/custom/trending_community_old.dart';
import 'package:finobird/models/chat/communities.dart';
import 'package:finobird/repository/community_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunitySearch extends StatefulWidget {
  const CommunitySearch({super.key, required this.trendingCommunities});

  final List<Communities>? trendingCommunities;

  @override
  State<CommunitySearch> createState() => _CommunitySearchState();
}

class _CommunitySearchState extends State<CommunitySearch> {
  CommunitiesRepo communityController = Get.put(CommunitiesRepo());

  var controller = TextEditingController();
  List<Communities> searchResults = <Communities>[].obs;

  @override
  void initState() {
    searchResults.addAll(widget.trendingCommunities ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() async {
      await communityController.searchCommunity(
          controller.text.toLowerCase(), 20);
      searchResults.clear();
      searchResults.addAll(
          communityController.searchCommunities.value.communities ?? []);
    });

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Trending Communities',
            textScaleFactor: 1,
            style: Styles.text.copyWith(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                placeholder: "Search",
                style: Styles.text,
                controller: controller,
              ),
            ),
            Expanded(
                child: GridView.builder(
              itemCount: searchResults.length,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 15,
              ),
              // const SliverGridDelegateWithMaxCrossAxisExtent(
              //   maxCrossAxisExtent: 200,
              //   childAspectRatio: 1 / 1,
              //   crossAxisSpacing: 5,
              //   mainAxisSpacing: 15,
              // ),
              itemBuilder: (context, index) {
                return TrendingCommunityOld(community: searchResults[index]);
              },
            ))
          ],
        ),
      ),
    );
  }
}
