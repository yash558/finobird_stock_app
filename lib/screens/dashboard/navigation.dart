// ignore_for_file: must_be_immutable, unnecessary_final

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:finobird/constants/colors.dart';
import 'package:finobird/repository/user_repo.dart';
import 'package:finobird/screens/chat/chats.dart';
import 'package:finobird/screens/dashboard/search_community.dart';
import 'package:finobird/screens/profile/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repository/authentication.dart';
import '../../repository/chat_repo.dart';
import '../../repository/community_repo.dart';
import '../../repository/feed_repo.dart';
import '../../repository/watchlist_repo.dart';
import '../feeds/feed.dart';
import 'home.dart';

class Navigation extends StatefulWidget {
  int? index = 0;
   Navigation({this.index,super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  CommunitiesRepo controller = Get.put(CommunitiesRepo());
  final ChatRepo chats = Get.put(ChatRepo());
  WatchlistRepo watchlist = Get.put(WatchlistRepo());
  var feed = Get.put(FeedRepo());
  final usRepo = Get.put(UserRepo());
  RxInt selected = 0.obs;

  @override
  void initState() {
    if(widget.index != null){
      setState(() {
        selected.value = widget.index!;
      });

    }
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      await watchlist.getWatchlists(100, true);
      await controller.getBannerLists(true);
      await controller.getCommunities(true);
      await feed.getAnnouncements();
      await feed.filterFeeds(more: false);
      await chats.getChats();
      getUserDeviceToken();
    });
    super.initState();
  }

  getUserDeviceToken() async {
    if(accessToken.value.isNotEmpty){
      await FirebaseMessaging.instance.getToken().then((val) {
        if(val != null){
          //  print('ndignidn $val');
          usRepo.addUserDeviceToken(val);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List body = [
      Home(
        search: TextEditingController(),
        ontap: () {
          selected.value = 3;
        },
      ),
      const Feeds(),
      const Chats(),
      const ProfileScreen(),
    ];
    final List<IconData> iconsList = [
      CupertinoIcons.house_fill,
      CupertinoIcons.collections_solid,
      CupertinoIcons.bubble_left_bubble_right_fill,
      CupertinoIcons.person_fill,
    ];
    final List<String> name = [
      "Home",
      "Feed",
      "Chat",
      "Profile",
    ];
    return Obx(
      () => Scaffold(
        body: body[selected.value],
        backgroundColor: Colors.blueGrey.shade50,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: body.length,
          tabBuilder: (index, isActive) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconsList[index],
                  color:
                      selected.value == index ? Colors.white : Colors.white54,
                  size: 22,
                ),
                const SizedBox(height: 5),
                Text(
                  name[index],
                  style: TextStyle(
                      color: selected.value == index
                          ? Colors.white
                          : Colors.white54,
                      fontSize: 10),
                ),
              ],
            );
          },
          // icons: const [
          //   Icons.home_rounded,
          //   LineIcons.blog,
          //   CupertinoIcons.bubble_left_bubble_right_fill_rounded,
          //   Icons.person,
          // ],
          activeIndex: selected.value,
          leftCornerRadius: 30,
          rightCornerRadius: 30,
          gapLocation: GapLocation.none,
          backgroundColor: primaryColor,
          onTap: (index) => selected.value = index,
          // activeColor: Colors.white,
          // inactiveColor: Colors.white54,
          // iconSize: 30,
          height: 55,
          blurEffect: true,
        ),
        floatingActionButton: selected.value == 2
            ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () {
                  Get.to(
                    () => CommunitySearch(
                      trendingCommunities: controller.communities.value.communities,
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
