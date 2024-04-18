class TickerRecommendation {
  String? ticker;
  List<RecommendedTickers>? recommendedTickers;

  TickerRecommendation({this.ticker, this.recommendedTickers});

  TickerRecommendation.fromJson(Map<String, dynamic> json) {
    ticker = json['ticker'];
    if (json['recommendedTickers'] != null) {
      recommendedTickers = <RecommendedTickers>[];
      json['recommendedTickers'].forEach((v) {
        recommendedTickers!.add(RecommendedTickers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['ticker'] = ticker;
    if (recommendedTickers != null) {
      data['recommendedTickers'] =
          recommendedTickers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecommendedTickers {
  String? ticker;
  double? score;

  RecommendedTickers({this.ticker, this.score});

  RecommendedTickers.fromJson(Map<String, dynamic> json) {
    ticker = json['ticker'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['ticker'] = ticker;
    data['score'] = score;
    return data;
  }
}
