import 'dart:convert';
import 'dart:developer';

import 'package:finobird/screens/dashboard/navigation.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/banner/banner_model.dart';
import '../models/watchlist/get_watchlist_by_id.dart';
import '../models/watchlist/get_watchlists.dart';
import 'authentication.dart';
import 'constants.dart';

class WatchlistRepo extends GetxController {
  var baseUrl = "${Constants.baseUrl}/api/v1/user/watchlists";

  Rx<GetWatchlists> myWatchlists = GetWatchlists(watchlists: []).obs;


  Rx<GetWatchlistById> getWatchlistById = GetWatchlistById().obs;

  ValueNotifier<bool> fetchWatchList = ValueNotifier(true);


  Future<void> getWatchlists(int limit, bool firstTime) async {
    if (firstTime) {
      fetchWatchList.value = true;
    }
    try {
      var request = http.Request('GET', Uri.parse(baseUrl));
      request.body = jsonEncode({
        "limit": limit,
      });
      request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        log(data);
        myWatchlists.value = GetWatchlists.fromJson(jsonDecode(data));
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
      fetchWatchList.value = false;
    }
  }

  // Future<void> getWatchlistUpdateCount(int watchlistId, int feedLastToken) async {

  // }

  createWatchlist(List companies, String name) async {
    var request = http.Request('POST', Uri.parse("$baseUrl/create"));

    request.body = jsonEncode({
      "name": name,
      "companyIds": companies,
    });

    request.headers.addAll({
      "Authorization": "Bearer ${accessToken.value}",
      'Content-Type': 'application/json',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
      Get.offAll(() =>  Navigation());
      Fluttertoast.showToast(msg: "Watchlist Created");
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  deleteWatchlist(int id) async {
    print('wwwwww $id');
    var request = http.Request('DELETE', Uri.parse("$baseUrl/$id"));

    request.headers.addAll({
      "Authorization": "Bearer ${accessToken.value}",
      'Content-Type': 'application/json',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Get.offAll(() =>  Navigation());
      Fluttertoast.showToast(msg: "Watchlist Deleted");
    } else {
      print(response.reasonPhrase.toString());
    }
  }

  getWatchlistDetails(int id) async {
    var request = http.Request('GET', Uri.parse("$baseUrl/$id"));

    request.headers.addAll({
      "Authorization": "Bearer ${accessToken.value}",
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      // log(data);
      getWatchlistById.value = GetWatchlistById.fromJson(jsonDecode(data));
      update();
      notifyChildrens();
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  updateWatchlist(List companies, int id, String name) async {
    var request = http.Request('PUT', Uri.parse("$baseUrl/$id"));

    request.body = jsonEncode({
      "name": name,
      "companyIds": companies,
    });

    request.headers.addAll({
      "Authorization": "Bearer ${accessToken.value}",
      'Content-Type': 'application/json',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      log(data);
      notifyChildrens();
     Get.offAll(() =>  Navigation());
      Fluttertoast.showToast(msg: "Watchlist Updated");
    } else {
      log(response.reasonPhrase.toString());
    }
  }



}
