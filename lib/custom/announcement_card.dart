import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repository/feed_repo.dart';
import '../constants/styles.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required FeedRepo feed,
    required this.index,
  }) : _feed = feed;

  final FeedRepo _feed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launchUrl(
          Uri.parse(
            _feed.announcements.value.table![index].nSURL!,
          ),
          mode: LaunchMode.externalApplication,
        );
      },
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          _feed.announcements.value.table![index].sLONGNAME!,
          style: Styles.text,
        ),
        subtitle: Text(
          _feed.announcements.value.table![index].hEADLINE!,
          overflow: TextOverflow.ellipsis,
          style: Styles.text,
        ),
        leading: Image.asset("assets/pdf.png"),
      ),
    );
  }
}
