import 'dart:convert';

import 'package:finobird/constants/colors.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finobird/repository/authentication.dart';
import 'constants.dart';

class BrowseCard extends StatefulWidget {
  BrowseCard({
    Key? key,
    required this.title,
    required this.ontap,
    required this.getWatchlistFeed,
    required this.watchlistId,
  }) : super(key: key);

  final String title;
  final Function() ontap;
  final Function() getWatchlistFeed;
  final int watchlistId;

  @override
  _BrowseCardState createState() => _BrowseCardState();
}

class _BrowseCardState extends State<BrowseCard> {
  int? lastFeedId;
  int feedCount = 0;

  @override
  void initState() async {
    await loadLastFeedId();
    await getWatchlistFeedData(widget.watchlistId);
    super.initState();
  }

  Future<void> loadLastFeedId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastFeedId = prefs.getInt('watch_${widget.watchlistId}_lastfeedid');
    });
  }

  Future<void> getWatchlistFeedData(int watchListId) async {
    try {
      print('lastfeedid $lastFeedId ######');
      print("watch List id: $watchListId");
      print("AccessToken: ${accessToken.value}");

      var request = http.Request(
        'GET',
        Uri.parse('${Constants.baseUrl}/api/v1/user/watchlists/feed-updates'),
      );
      request.body = jsonEncode({
        "watchListId": watchListId,
        "feedLastToken": lastFeedId ?? 0,
      });
      request.headers.addAll({
        "Authorization": "Bearer ${accessToken.value}",
        "Content-Type": "application/json",
      });

      print("Request Data: ${request.toString()}");

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      print("Response Status Code: ${response.statusCode}");
      print("Response Reason Phrase: ${response.reasonPhrase}");
      print("Response Data: $data");

      if (response.statusCode == 200) {
        var finalData = jsonDecode(data);

        if (finalData["count"] != null) {
          setState(() {
            feedCount = finalData["count"].toInt();
          });
          print('Count: $feedCount');
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: InkWell(
        onTap: widget.ontap,
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primaryColor,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.title,
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.text.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: () async {
                  await loadLastFeedId();
                  
                  await widget.getWatchlistFeed();
                },
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: feedButtonColor,
                          ),
                          child: Center(
                            child: Text(
                              "Feeds",
                              style: Styles.text.copyWith(
                                fontSize: 10,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                    if (lastFeedId != null && lastFeedId! > 0)
                      Positioned(
                        right: 10,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "$feedCount",
                              style: Styles.text.copyWith(
                                fontSize: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
