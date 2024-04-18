class DetailedTickerInfo {
  SummaryDetail? summaryDetail;
  Price? price;

  DetailedTickerInfo({this.summaryDetail, this.price});

  DetailedTickerInfo.fromJson(Map<String, dynamic> json) {
    summaryDetail = json['summaryDetail'] != null
        ? SummaryDetail.fromJson(json['summaryDetail'])
        : null;
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (summaryDetail != null) {
      data['summaryDetail'] = summaryDetail!.toJson();
    }
    if (price != null) {
      data['price'] = price!.toJson();
    }
    return data;
  }
}

class SummaryDetail {
  num? maxAge;
  num? priceHint;
  num? previousClose;
  num? open;
  num? dayLow;
  num? dayHigh;
  num? regularMarketPreviousClose;
  num? regularMarketOpen;
  num? regularMarketDayLow;
  num? regularMarketDayHigh;
  num? dividendRate;
  num? dividendYield;
  String? exDividendDate;
  num? payoutRatio;
  num? beta;
  num? trailingPE;
  num? volume;
  num? regularMarketVolume;
  num? averageVolume;
  num? averageVolume10days;
  num? averageDailyVolume10Day;
  num? bid;
  num? ask;
  num? bidSize;
  num? askSize;
  num? marketCap;
  num? fiftyTwoWeekLow;
  num? fiftyTwoWeekHigh;
  num? priceToSalesTrailing12Months;
  num? fiftyDayAverage;
  num? twoHundredDayAverage;
  num? trailingAnnualDividendRate;
  num? trailingAnnualDividendYield;
  String? currency;
  String? fromCurrency;
  String? toCurrency;
  String? lastMarket;
  String? coinMarketCapLink;
  String? algorithm;
  bool? tradeable;

  SummaryDetail(
      {this.maxAge,
      this.priceHint,
      this.previousClose,
      this.open,
      this.dayLow,
      this.dayHigh,
      this.regularMarketPreviousClose,
      this.regularMarketOpen,
      this.regularMarketDayLow,
      this.regularMarketDayHigh,
      this.dividendRate,
      this.dividendYield,
      this.exDividendDate,
      this.payoutRatio,
      this.beta,
      this.trailingPE,
      this.volume,
      this.regularMarketVolume,
      this.averageVolume,
      this.averageVolume10days,
      this.averageDailyVolume10Day,
      this.bid,
      this.ask,
      this.bidSize,
      this.askSize,
      this.marketCap,
      this.fiftyTwoWeekLow,
      this.fiftyTwoWeekHigh,
      this.priceToSalesTrailing12Months,
      this.fiftyDayAverage,
      this.twoHundredDayAverage,
      this.trailingAnnualDividendRate,
      this.trailingAnnualDividendYield,
      this.currency,
      this.fromCurrency,
      this.toCurrency,
      this.lastMarket,
      this.coinMarketCapLink,
      this.algorithm,
      this.tradeable});

  SummaryDetail.fromJson(Map<String, dynamic> json) {
    maxAge = json['maxAge'];
    priceHint = json['priceHint'];
    previousClose = json['previousClose'];
    open = json['open'];
    dayLow = json['dayLow'];
    dayHigh = json['dayHigh'];
    regularMarketPreviousClose = json['regularMarketPreviousClose'];
    regularMarketOpen = json['regularMarketOpen'];
    regularMarketDayLow = json['regularMarketDayLow'];
    regularMarketDayHigh = json['regularMarketDayHigh'];
    dividendRate = json['dividendRate'];
    dividendYield = json['dividendYield'];
    exDividendDate = json['exDividendDate'];
    payoutRatio = json['payoutRatio'];
    beta = json['beta'];
    trailingPE = json['trailingPE'];
    volume = json['volume'];
    regularMarketVolume = json['regularMarketVolume'];
    averageVolume = json['averageVolume'];
    averageVolume10days = json['averageVolume10days'];
    averageDailyVolume10Day = json['averageDailyVolume10Day'];
    bid = json['bid'];
    ask = json['ask'];
    bidSize = json['bidSize'];
    askSize = json['askSize'];
    marketCap = json['marketCap'];
    fiftyTwoWeekLow = json['fiftyTwoWeekLow'];
    fiftyTwoWeekHigh = json['fiftyTwoWeekHigh'];
    priceToSalesTrailing12Months = json['priceToSalesTrailing12Months'];
    fiftyDayAverage = json['fiftyDayAverage'];
    twoHundredDayAverage = json['twoHundredDayAverage'];
    trailingAnnualDividendRate = json['trailingAnnualDividendRate'];
    trailingAnnualDividendYield = json['trailingAnnualDividendYield'];
    currency = json['currency'];
    fromCurrency = json['fromCurrency'];
    toCurrency = json['toCurrency'];
    lastMarket = json['lastMarket'];
    coinMarketCapLink = json['coinMarketCapLink'];
    algorithm = json['algorithm'];
    tradeable = json['tradeable'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['maxAge'] = maxAge;
    data['priceHint'] = priceHint;
    data['previousClose'] = previousClose;
    data['open'] = open;
    data['dayLow'] = dayLow;
    data['dayHigh'] = dayHigh;
    data['regularMarketPreviousClose'] = regularMarketPreviousClose;
    data['regularMarketOpen'] = regularMarketOpen;
    data['regularMarketDayLow'] = regularMarketDayLow;
    data['regularMarketDayHigh'] = regularMarketDayHigh;
    data['dividendRate'] = dividendRate;
    data['dividendYield'] = dividendYield;
    data['exDividendDate'] = exDividendDate;
    data['payoutRatio'] = payoutRatio;
    data['beta'] = beta;
    data['trailingPE'] = trailingPE;
    data['volume'] = volume;
    data['regularMarketVolume'] = regularMarketVolume;
    data['averageVolume'] = averageVolume;
    data['averageVolume10days'] = averageVolume10days;
    data['averageDailyVolume10Day'] = averageDailyVolume10Day;
    data['bid'] = bid;
    data['ask'] = ask;
    data['bidSize'] = bidSize;
    data['askSize'] = askSize;
    data['marketCap'] = marketCap;
    data['fiftyTwoWeekLow'] = fiftyTwoWeekLow;
    data['fiftyTwoWeekHigh'] = fiftyTwoWeekHigh;
    data['priceToSalesTrailing12Months'] = priceToSalesTrailing12Months;
    data['fiftyDayAverage'] = fiftyDayAverage;
    data['twoHundredDayAverage'] = twoHundredDayAverage;
    data['trailingAnnualDividendRate'] = trailingAnnualDividendRate;
    data['trailingAnnualDividendYield'] = trailingAnnualDividendYield;
    data['currency'] = currency;
    data['fromCurrency'] = fromCurrency;
    data['toCurrency'] = toCurrency;
    data['lastMarket'] = lastMarket;
    data['coinMarketCapLink'] = coinMarketCapLink;
    data['algorithm'] = algorithm;
    data['tradeable'] = tradeable;
    return data;
  }
}

class Price {
  num? maxAge;
  num? regularMarketChangePercent;
  num? regularMarketChange;
  String? regularMarketTime;
  num? priceHint;
  num? regularMarketPrice;
  num? regularMarketDayHigh;
  num? regularMarketDayLow;
  num? regularMarketVolume;
  num? averageDailyVolume10Day;
  num? averageDailyVolume3Month;
  num? regularMarketPreviousClose;
  String? regularMarketSource;
  num? regularMarketOpen;
  String? exchange;
  String? exchangeName;
  num? exchangeDataDelayedBy;
  String? marketState;
  String? quoteType;
  String? symbol;
  String? underlyingSymbol;
  String? shortName;
  String? longName;
  String? currency;
  String? quoteSourceName;
  String? currencySymbol;
  String? fromCurrency;
  String? toCurrency;
  String? lastMarket;
  num? marketCap;

  Price(
      {this.maxAge,
      this.regularMarketChangePercent,
      this.regularMarketChange,
      this.regularMarketTime,
      this.priceHint,
      this.regularMarketPrice,
      this.regularMarketDayHigh,
      this.regularMarketDayLow,
      this.regularMarketVolume,
      this.averageDailyVolume10Day,
      this.averageDailyVolume3Month,
      this.regularMarketPreviousClose,
      this.regularMarketSource,
      this.regularMarketOpen,
      this.exchange,
      this.exchangeName,
      this.exchangeDataDelayedBy,
      this.marketState,
      this.quoteType,
      this.symbol,
      this.underlyingSymbol,
      this.shortName,
      this.longName,
      this.currency,
      this.quoteSourceName,
      this.currencySymbol,
      this.fromCurrency,
      this.toCurrency,
      this.lastMarket,
      this.marketCap});

  Price.fromJson(Map<String, dynamic> json) {
    maxAge = json['maxAge'];
    regularMarketChangePercent = json['regularMarketChangePercent'];
    regularMarketChange = json['regularMarketChange'];
    regularMarketTime = json['regularMarketTime'];
    priceHint = json['priceHint'];
    regularMarketPrice = json['regularMarketPrice'];
    regularMarketDayHigh = json['regularMarketDayHigh'];
    regularMarketDayLow = json['regularMarketDayLow'];
    regularMarketVolume = json['regularMarketVolume'];
    averageDailyVolume10Day = json['averageDailyVolume10Day'];
    averageDailyVolume3Month = json['averageDailyVolume3Month'];
    regularMarketPreviousClose = json['regularMarketPreviousClose'];
    regularMarketSource = json['regularMarketSource'];
    regularMarketOpen = json['regularMarketOpen'];
    exchange = json['exchange'];
    exchangeName = json['exchangeName'];
    exchangeDataDelayedBy = json['exchangeDataDelayedBy'];
    marketState = json['marketState'];
    quoteType = json['quoteType'];
    symbol = json['symbol'];
    underlyingSymbol = json['underlyingSymbol'];
    shortName = json['shortName'];
    longName = json['longName'];
    currency = json['currency'];
    quoteSourceName = json['quoteSourceName'];
    currencySymbol = json['currencySymbol'];
    fromCurrency = json['fromCurrency'];
    toCurrency = json['toCurrency'];
    lastMarket = json['lastMarket'];
    marketCap = json['marketCap'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['maxAge'] = maxAge;
    data['regularMarketChangePercent'] = regularMarketChangePercent;
    data['regularMarketChange'] = regularMarketChange;
    data['regularMarketTime'] = regularMarketTime;
    data['priceHint'] = priceHint;
    data['regularMarketPrice'] = regularMarketPrice;
    data['regularMarketDayHigh'] = regularMarketDayHigh;
    data['regularMarketDayLow'] = regularMarketDayLow;
    data['regularMarketVolume'] = regularMarketVolume;
    data['averageDailyVolume10Day'] = averageDailyVolume10Day;
    data['averageDailyVolume3Month'] = averageDailyVolume3Month;
    data['regularMarketPreviousClose'] = regularMarketPreviousClose;
    data['regularMarketSource'] = regularMarketSource;
    data['regularMarketOpen'] = regularMarketOpen;
    data['exchange'] = exchange;
    data['exchangeName'] = exchangeName;
    data['exchangeDataDelayedBy'] = exchangeDataDelayedBy;
    data['marketState'] = marketState;
    data['quoteType'] = quoteType;
    data['symbol'] = symbol;
    data['underlyingSymbol'] = underlyingSymbol;
    data['shortName'] = shortName;
    data['longName'] = longName;
    data['currency'] = currency;
    data['quoteSourceName'] = quoteSourceName;
    data['currencySymbol'] = currencySymbol;
    data['fromCurrency'] = fromCurrency;
    data['toCurrency'] = toCurrency;
    data['lastMarket'] = lastMarket;
    data['marketCap'] = marketCap;
    return data;
  }
}
