import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../custom/feed_post.dart';
import '../../custom/shimmer_skelton.dart';
import '../../repository/authentication.dart';
import '../../repository/feed_repo.dart';
import '../../constants/styles.dart';
import '../chat/search.dart';
import 'filter_mixin.dart';

class Feeds extends StatefulWidget {
  const Feeds({super.key});

  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> with FilterMixin {
  final FeedRepo controller = Get.put(FeedRepo());
  final ScrollController scrollController = ScrollController();

  addScrollListner() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (controller.filtered) {
          controller.filterFeeds(more: true);
        } else {
          // controller.fetchFeeds(true);
          controller.filterFeeds(more: true);
        }
      }
    });
  }

  @override
  void initState() {
    addScrollListner();
    super.initState();
  }

  @override
  void dispose() {
    controller.resetFilter(apiCall: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Get.mediaQuery.padding.top),
        Row(
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                 await Clipboard.setData(ClipboardData(text: accessToken.value));
              },
              child: Text(
                'Feeds',
                textScaleFactor: 1,
                style: Styles.semiBold.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Get.to(() => const FeedSearch());
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                filterTheFeeds(context, controller);
              },
              icon: const Icon(LineIcons.filter),
            ),
          ],
        ),
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: controller.fetchingFeeds,
            builder: (context, feedLoading, child) => feedLoading
                ? ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 10,
                        ),
                        child: Skeleton(
                          borderRadius: 20,
                          height: 270,
                        ),
                      );
                    },
                  )
                : ValueListenableBuilder<bool>(
                    valueListenable: controller.feedUpdate,
                    builder: (context, updated, child) =>
                        controller.feedList.value.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  if (controller.filtered) {
                                    controller.filterFeeds(more: false);
                                  } else {
                                    // controller.fetchFeeds(false);
                                    controller.filterFeeds(more: false);
                                  }
                                },
                                child: ListView.builder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.only(top: 8),
                                  itemCount: controller.feedList.value.length,
                                  itemBuilder: (context, i) => FeedPost(
                                    feed: controller.feedList.value[i],
                                    index: i,
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  "No Feeds",
                                  textScaleFactor: 1,
                                  style: Styles.semiBold.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                  ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: controller.fetchingMoreFeeds,
          builder: (context, moreLoading, child) => moreLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
