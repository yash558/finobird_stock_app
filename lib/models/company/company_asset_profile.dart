class CompanyAssetProfile {
  AssetProfile? assetProfile;

  CompanyAssetProfile({this.assetProfile});

  CompanyAssetProfile.fromJson(Map<String, dynamic> json) {
    assetProfile = json['assetProfile'] != null
        ? AssetProfile.fromJson(json['assetProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (assetProfile != null) {
      data['assetProfile'] = assetProfile!.toJson();
    }
    return data;
  }
}

class AssetProfile {
  String? address1;
  String? address2;
  String? city;
  String? zip;
  String? country;
  String? phone;
  String? fax;
  String? website;
  String? industry;
  String? sector;
  String? longBusinessSummary;
  int? fullTimeEmployees;
  List<CompanyOfficers>? companyOfficers;
  int? auditRisk;
  int? boardRisk;
  int? compensationRisk;
  int? shareHolderRightsRisk;
  int? overallRisk;
  String? governanceEpochDate;
  String? compensationAsOfEpochDate;
  int? maxAge;

  AssetProfile(
      {this.address1,
      this.address2,
      this.city,
      this.zip,
      this.country,
      this.phone,
      this.fax,
      this.website,
      this.industry,
      this.sector,
      this.longBusinessSummary,
      this.fullTimeEmployees,
      this.companyOfficers,
      this.auditRisk,
      this.boardRisk,
      this.compensationRisk,
      this.shareHolderRightsRisk,
      this.overallRisk,
      this.governanceEpochDate,
      this.compensationAsOfEpochDate,
      this.maxAge});

  AssetProfile.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    zip = json['zip'];
    country = json['country'];
    phone = json['phone'];
    fax = json['fax'];
    website = json['website'];
    industry = json['industry'];
    sector = json['sector'];
    longBusinessSummary = json['longBusinessSummary'];
    fullTimeEmployees = json['fullTimeEmployees'];
    if (json['companyOfficers'] != null) {
      companyOfficers = <CompanyOfficers>[];
      json['companyOfficers'].forEach((v) {
        companyOfficers!.add(CompanyOfficers.fromJson(v));
      });
    }
    auditRisk = json['auditRisk'];
    boardRisk = json['boardRisk'];
    compensationRisk = json['compensationRisk'];
    shareHolderRightsRisk = json['shareHolderRightsRisk'];
    overallRisk = json['overallRisk'];
    governanceEpochDate = json['governanceEpochDate'];
    compensationAsOfEpochDate = json['compensationAsOfEpochDate'];
    maxAge = json['maxAge'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['zip'] = zip;
    data['country'] = country;
    data['phone'] = phone;
    data['fax'] = fax;
    data['website'] = website;
    data['industry'] = industry;
    data['sector'] = sector;
    data['longBusinessSummary'] = longBusinessSummary;
    data['fullTimeEmployees'] = fullTimeEmployees;
    if (companyOfficers != null) {
      data['companyOfficers'] =
          companyOfficers!.map((v) => v.toJson()).toList();
    }
    data['auditRisk'] = auditRisk;
    data['boardRisk'] = boardRisk;
    data['compensationRisk'] = compensationRisk;
    data['shareHolderRightsRisk'] = shareHolderRightsRisk;
    data['overallRisk'] = overallRisk;
    data['governanceEpochDate'] = governanceEpochDate;
    data['compensationAsOfEpochDate'] = compensationAsOfEpochDate;
    data['maxAge'] = maxAge;
    return data;
  }
}

class CompanyOfficers {
  int? maxAge;
  String? name;
  int? age;
  String? title;
  int? yearBorn;
  int? exercisedValue;
  int? unexercisedValue;
  int? fiscalYear;
  int? totalPay;

  CompanyOfficers(
      {this.maxAge,
      this.name,
      this.age,
      this.title,
      this.yearBorn,
      this.exercisedValue,
      this.unexercisedValue,
      this.fiscalYear,
      this.totalPay});

  CompanyOfficers.fromJson(Map<String, dynamic> json) {
    maxAge = json['maxAge'];
    name = json['name'];
    age = json['age'];
    title = json['title'];
    yearBorn = json['yearBorn'];
    exercisedValue = json['exercisedValue'];
    unexercisedValue = json['unexercisedValue'];
    fiscalYear = json['fiscalYear'];
    totalPay = json['totalPay'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['maxAge'] = maxAge;
    data['name'] = name;
    data['age'] = age;
    data['title'] = title;
    data['yearBorn'] = yearBorn;
    data['exercisedValue'] = exercisedValue;
    data['unexercisedValue'] = unexercisedValue;
    data['fiscalYear'] = fiscalYear;
    data['totalPay'] = totalPay;
    return data;
  }
}
