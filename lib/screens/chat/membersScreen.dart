// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom/shimmer_skelton.dart';
import '../../custom/user_image_error_widget.dart';
import '../../repository/community_repo.dart';

class MembersScreen extends StatelessWidget {
  MembersScreen({
    super.key,
    required this.id,
  });
  final int id;

  final CommunitiesRepo communities = CommunitiesRepo();
  @override
  Widget build(BuildContext context) {
    communities.getMembers(id);
    return Obx(
      () => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            leadingWidth: 70,
            titleSpacing: 0,
            backgroundColor: const Color(0xFF4AB5E5).withOpacity(0.5),
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ),
            title: InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  'Members',
                  style: Styles.text.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: communities.communityMember.value.members != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: communities.communityMember.value
                                      .members![index].avatarUrl ??
                                  "",
                              placeholder: (context, url) =>
                                  const UserErrorWidget(),
                              errorWidget: (context, url, error) =>
                                  const UserErrorWidget(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          (communities.communityMember.value.members != null &&
                                  communities.communityMember.value
                                          .members![index].firstName !=
                                      null)
                              ? "${communities.communityMember.value.members![index].firstName} ${communities.communityMember.value.members![index].lastName ?? ""}"
                              : "",
                          style: Styles.text.copyWith(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Skeleton(borderRadius: 40, height: 40, width: 40),
                        const SizedBox(width: 20),
                        Skeleton(borderRadius: 5, height: 20, width: 250)
                      ],
                    ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 1,
            );
          },
          itemCount: communities.communityMember.value.members?.length ?? 0,
        ),
      ),
    );
  }
}
