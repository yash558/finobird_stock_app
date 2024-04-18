// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:finobird/repository/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/banner/banner_model.dart';
import '../models/chat/fetch_communities.dart';
import '../models/chat/get_community_members.dart';
import '../models/chat/get_community_profile.dart';
import '../models/chat/search_communities.dart';
import 'authentication.dart';

class CommunitiesRepo extends GetxController {
  static const baseUrl = "${Constants.baseUrl}/api/v1/chat/community";
  var bannerUrl = "${Constants.baseUrl}/api/v1/banner";
  Rx<FetchCommunities> communities = FetchCommunities(communities: []).obs;
  Rx<SearchCommunities> searchCommunities = SearchCommunities().obs;
  Rx<GetCommunityProfile> communityProfile = GetCommunityProfile().obs;
  Rx<GetCommunityMembers> communityMember = GetCommunityMembers().obs;

  ValueNotifier<bool> fetchCommunity = ValueNotifier(true);

  Rx<BannerModelList> bannerModelList = BannerModelList(states: []).obs;



  ValueNotifier<bool> bannerList = ValueNotifier(true);

  final CarouselController _controller = CarouselController();

  RxInt bannerCurrentIndex = 0.obs;

  Future<void> getCommunities(bool firstTime) async {
    if (firstTime) {
      fetchCommunity.value = true;
    }
    try {
      var request = http.Request('GET', Uri.parse(baseUrl));
      request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        log(data);
        communities.value = FetchCommunities.fromJson(
          jsonDecode(data),
        );
        update();
        notifyChildrens();
      } else {
        log(response.reasonPhrase.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    if (firstTime) {
      fetchCommunity.value = false;
    }
  }

  Future<void> searchCommunity(String name, int limit) async {
    var request = http.Request('GET', Uri.parse(baseUrl));
    request.body = jsonEncode({
      "count": limit,
      "filters": {
        "query": name,
      },
    });

    var headersList = {
        'Accept': '*/*',
        'Authorization': 'Bearer ${accessToken.value}',
        'Content-Type': 'application/json'
    };
    request.headers.addAll(headersList);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      // log(data);
      searchCommunities.value = SearchCommunities.fromJson(
        jsonDecode(data),
      );
      update();
      notifyChildrens();
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  Future<void> getCommunityDetails(int id) async {
    try {
      var request = http.Request('GET', Uri.parse('$baseUrl/$id'));
      request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        // log(data);
        communityProfile.value = GetCommunityProfile.fromJson(
          jsonDecode(data),
        );
        update();
        notifyChildrens();
      } else {
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }


  Future<void> getCommunityDetailsStringId(String id) async {
    try {
      var request = http.Request('GET', Uri.parse('$baseUrl/$id'));
      request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        // log(data);
        communityProfile.value = GetCommunityProfile.fromJson(
          jsonDecode(data),
        );
        update();
        notifyChildrens();
      } else {
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }


  void getMembers(int id) async {
    var request = http.Request('GET', Uri.parse('$baseUrl/$id/members'));
    request.body = jsonEncode({
      "count": 100,
    });
    request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      // log(data);
      communityMember.value = GetCommunityMembers.fromJson(
        jsonDecode(data),
      );
      update();
      notifyChildrens();
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  Future joinCommunity(int id) async {
    var request = http.Request('POST', Uri.parse('$baseUrl/$id/join'));
    request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
      log("community joined");
      Fluttertoast.showToast(msg: "Community Joined");
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  Future leaveCommunity(int id) async {
    var request = http.Request('POST', Uri.parse('$baseUrl/$id/leave'));
    request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
      log("community leaved");
      Fluttertoast.showToast(msg: "Community Left Successfully");
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  Future<void> getBannerLists(bool firstTime) async {
    if (firstTime) {
      bannerList.value = true;
    }
    try {
      var request = http.Request('GET', Uri.parse(bannerUrl));
      // request.body = jsonEncode({
      //   "limit": limit,
      // });
      request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        bannerModelList.value = BannerModelList.fromJson(jsonDecode(data));
        update();
        notifyChildrens();
      } else {
        log("======>   ${response.statusCode}");
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log("======>  ERROR ::::  $e");
    }
    if (firstTime) {
      bannerList.value = false;
    }
  }
}
