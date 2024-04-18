// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:finobird/constants/colors.dart';
import 'package:finobird/models/chat/communities.dart';
import 'package:flutter/material.dart';

// import '../../custom/trending_community.dart';
import '../../custom/trending_community_old.dart';
import '../../constants/styles.dart';

class TrendingCommunities extends StatelessWidget {
  final List<Communities>? communities;
  const TrendingCommunities({super.key, this.communities});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: primaryColor,
    //     iconTheme: const IconThemeData(
    //       color: Colors.white,
    //     ),
    //     title: Text(
    //       'Trending Communities',
    //       textScaleFactor: 1,
    //       style: Styles.text.copyWith(
    //         color: Colors.white,
    //         fontSize: 18,
    //       ),
    //     ),
    //     centerTitle: true,
    //   ),
    //   body:
    return GridView.builder(
      itemCount: communities?.length ?? 0,
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
        return TrendingCommunityOld(
          community: communities![index],
        );
      },
    );
  }
}
