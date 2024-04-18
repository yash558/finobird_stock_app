// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:finobird/repository/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:html/dom.dart' as dom;
// import 'package:html/parser.dart' as parser;

import '../models/company/company_asset_profile.dart';
import '../models/company/detailed_ticker_info.dart';
import '../models/company/search_company.dart';
import '../models/company/stock_chart.dart';
import 'authentication.dart';

class CompanyRepo extends GetxController {
  var baseUrl = "${Constants.baseUrl}/api/v1/company";
  Rx<SearchCompany> tickerSearch = SearchCompany().obs;
  // Rx<TickerRecommendations> tickerRecommendations = TickerRecommendations().obs;
  Rx<DetailedTickerInfo>? basicTickerInfo = DetailedTickerInfo().obs;
  Rx<DetailedTickerInfo>? detailedInfo = DetailedTickerInfo().obs;
  Rx<CompanyAssetProfile> assetProfile = CompanyAssetProfile().obs;
  Rx<StockChart> chartData = StockChart().obs;

  Rx<bool> isdetailedTickerInfoLoading = false.obs;
  Rx<bool> isgetAssetProfileLoading = false.obs;
  Rx<bool> ischartLoading = false.obs;

  Future<void> search(String company, int limit, num? startToken) async {
    try {
      var headersList = {
        'Accept': '*/*',
        'Authorization': 'Bearer ${accessToken.value}',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('$baseUrl/search');

      var body = {
        "query": company,
        "limit": limit,
      };

      var req = http.Request('GET', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);
      log("=====>  REQUEST LOG  ::::\nURL:==> ${req.url}\nHEADER:==> ${req.headers}\nBODY:==> ${req.body}");

      var res = await req.send();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var data = await res.stream.bytesToString();
        log("=====>  Response Body ::::  $data");
        tickerSearch.value = SearchCompany.fromJson(
          jsonDecode(data),
        );
        update();
        notifyChildrens();
      } else {
        log(res.reasonPhrase.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  // tickerRecommendation(String ticker) async {
  //   try {
  //     var request =
  //         http.Request('GET', Uri.parse('$baseUrl/ticker-recommendation'));
  //     request.body = jsonEncode({"ticker": ticker});
  //     request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       log(await response.stream.bytesToString());
  //       tickerRecommendations.value = TickerRecommendations.fromJson(
  //         jsonDecode(await response.stream.bytesToString()),
  //       );
  //       update();
  //       notifyChildrens();
  //     } else {
  //       log(response.reasonPhrase.toString());
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  // }

  // tickerInfo(String ticker) async {
  //   try {
  //     var request = http.Request('GET', Uri.parse('$baseUrl/quote'));
  //     request.body = jsonEncode({"ticker": ticker});

  //     request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       var data = await response.stream.bytesToString();
  //       // log(data);
  //       basicTickerInfo!.value = BasicTickerInfo.fromJson(
  //         jsonDecode(data),
  //       );
  //       update();
  //       notifyChildrens();
  //     } else {
  //       log(response.reasonPhrase.toString());
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  // }

  detailedTickerInfo(String ticker) async {
    isdetailedTickerInfoLoading.value = true;
    try {
      var headersList = {
        'Accept': '*/*',
        'Authorization': 'Bearer ${accessToken.value}',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
        '$baseUrl/quote-summary',
      );

      var body = {
        "ticker": ticker,
      };

      var req = http.Request('GET', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      log("=====>  REQUEST LOG  ::::\nURL:==> ${req.url}\nHEADER:==> ${req.headers}\nBODY:==> ${req.body}");

      var res = await req.send();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var data = await res.stream.bytesToString();
        log("REsponse body :::  $data");
        detailedInfo!.value = DetailedTickerInfo.fromJson(
          jsonDecode(data),
        );
        update();
        notifyChildrens();
      } else {
        log("======>  Status Code  :::::  ${res.statusCode}");
        log(res.reasonPhrase.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isdetailedTickerInfoLoading.value = false;
    }
  }

  getAssetProfile(String ticker) async {
    isgetAssetProfileLoading.value = true;
    try {
      var headersList = {
        'Accept': '*/*',
        'Authorization': 'Bearer ${accessToken.value}',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
        '$baseUrl/quote-summary',
      );

      var body = {
        "ticker": ticker,
        "options": [
          "assetProfile",
        ]
      };

      var req = http.Request('GET', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);
      log("=====>  REQUEST LOG  ::::\nURL:==> ${req.url}\nHEADER:==> ${req.headers}\nBODY:==> ${req.body}");
      var res = await req.send();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var data = await res.stream.bytesToString();
        log("RESPONSE :::  $data");
        assetProfile.value = CompanyAssetProfile.fromJson(
          jsonDecode(data),
        );
        update();
        notifyChildrens();
      } else {
        log("=====>  Status Code ::::  ${res.statusCode}");
        log(res.reasonPhrase.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isgetAssetProfileLoading.value = false;
    }
  }

  chart(String ticker, String range, String interval) async {
    ischartLoading.value = true;
    try {
      var headersList = {
        'Accept': '*/*',
        'Authorization': 'Bearer ${accessToken.value}',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('$baseUrl/chart');

      var body = {
        "ticker": ticker,
        "range": range,
        "interval": interval,
      };

      var req = http.Request('GET', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      log("=====>  REQUEST LOG  ::::\nURL:==> ${req.url}\nHEADER:==> ${req.headers}\nBODY:==> ${req.body}");
      var res = await req.send();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var data = await res.stream.bytesToString();
        log("RESPONSE :::  $data");
        chartData.value = StockChart.fromJson(
          jsonDecode(data),
        );
        update();
        notifyChildrens();
      } else {
        log("=====>  Status Code ::::  ${res.statusCode}");
        log(res.reasonPhrase.toString());
      }
    } catch (e) {
      log(e.toString());
    }
    ischartLoading.value = false;
  }
}
