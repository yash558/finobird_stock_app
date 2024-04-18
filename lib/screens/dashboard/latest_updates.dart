// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../../custom/announcement_card.dart';
import '../../constants/styles.dart';

class Announcements extends StatelessWidget {
  const Announcements({super.key, required this.announcements});
  final announcements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4AB5E5).withOpacity(0.5),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Announcements',
          textScaleFactor: 1,
          style: Styles.text.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: announcements.announcements.value.table!.length,
        itemBuilder: (context, index) {
          return AnnouncementCard(
            feed: announcements,
            index: index,
          );
        },
      ),
    );
  }
}
