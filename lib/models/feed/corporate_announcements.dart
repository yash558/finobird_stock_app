class CorporateAnnouncements {
  List<Table>? table;
  List<Table1>? table1;

  CorporateAnnouncements({this.table, this.table1});

  CorporateAnnouncements.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      table = <Table>[];
      json['Table'].forEach((v) {
        table!.add(Table.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      table1 = <Table1>[];
      json['Table1'].forEach((v) {
        table1!.add(Table1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (table != null) {
      data['Table'] = table!.map((v) => v.toJson()).toList();
    }
    if (table1 != null) {
      data['Table1'] = table1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table {
  String? nEWSID;
  int? sCRIPCD;
  String? xMLNAME;
  String? nEWSSUB;
  String? dTTM;
  String? nEWSDT;
  int? cRITICALNEWS;
  String? aNNOUNCEMENTTYPE;
  String? qUARTERID;
  String? fILESTATUS;
  String? aTTACHMENTNAME;
  String? mORE;
  String? hEADLINE;
  String? cATEGORYNAME;
  int? oLD;
  int? rN;
  int? pDFFLAG;
  String? nSURL;
  String? sLONGNAME;
  int? aGENDAID;
  int? totalPageCnt;
  String? newsSubmissionDt;
  String? dissemDT;
  String? timeDiff;
  int? fldAttachsize;
  String? aTTACHMENTURL;

  Table(
      {this.nEWSID,
      this.sCRIPCD,
      this.xMLNAME,
      this.nEWSSUB,
      this.dTTM,
      this.nEWSDT,
      this.cRITICALNEWS,
      this.aNNOUNCEMENTTYPE,
      this.qUARTERID,
      this.fILESTATUS,
      this.aTTACHMENTNAME,
      this.mORE,
      this.hEADLINE,
      this.cATEGORYNAME,
      this.oLD,
      this.rN,
      this.pDFFLAG,
      this.nSURL,
      this.sLONGNAME,
      this.aGENDAID,
      this.totalPageCnt,
      this.newsSubmissionDt,
      this.dissemDT,
      this.timeDiff,
      this.fldAttachsize,
      this.aTTACHMENTURL});

  Table.fromJson(Map<String, dynamic> json) {
    nEWSID = json['NEWSID'];
    sCRIPCD = json['SCRIP_CD'];
    xMLNAME = json['XML_NAME'];
    nEWSSUB = json['NEWSSUB'];
    dTTM = json['DT_TM'];
    nEWSDT = json['NEWS_DT'];
    cRITICALNEWS = json['CRITICALNEWS'];
    aNNOUNCEMENTTYPE = json['ANNOUNCEMENT_TYPE'];
    qUARTERID = json['QUARTER_ID'];
    fILESTATUS = json['FILESTATUS'];
    aTTACHMENTNAME = json['ATTACHMENTNAME'];
    mORE = json['MORE'];
    hEADLINE = json['HEADLINE'];
    cATEGORYNAME = json['CATEGORYNAME'];
    oLD = json['OLD'];
    rN = json['RN'];
    pDFFLAG = json['PDFFLAG'];
    nSURL = json['NSURL'];
    sLONGNAME = json['SLONGNAME'];
    aGENDAID = json['AGENDA_ID'];
    totalPageCnt = json['TotalPageCnt'];
    newsSubmissionDt = json['News_submission_dt'];
    dissemDT = json['DissemDT'];
    timeDiff = json['TimeDiff'];
    fldAttachsize = json['Fld_Attachsize'];
    aTTACHMENTURL = json['ATTACHMENTURL'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['NEWSID'] = nEWSID;
    data['SCRIP_CD'] = sCRIPCD;
    data['XML_NAME'] = xMLNAME;
    data['NEWSSUB'] = nEWSSUB;
    data['DT_TM'] = dTTM;
    data['NEWS_DT'] = nEWSDT;
    data['CRITICALNEWS'] = cRITICALNEWS;
    data['ANNOUNCEMENT_TYPE'] = aNNOUNCEMENTTYPE;
    data['QUARTER_ID'] = qUARTERID;
    data['FILESTATUS'] = fILESTATUS;
    data['ATTACHMENTNAME'] = aTTACHMENTNAME;
    data['MORE'] = mORE;
    data['HEADLINE'] = hEADLINE;
    data['CATEGORYNAME'] = cATEGORYNAME;
    data['OLD'] = oLD;
    data['RN'] = rN;
    data['PDFFLAG'] = pDFFLAG;
    data['NSURL'] = nSURL;
    data['SLONGNAME'] = sLONGNAME;
    data['AGENDA_ID'] = aGENDAID;
    data['TotalPageCnt'] = totalPageCnt;
    data['News_submission_dt'] = newsSubmissionDt;
    data['DissemDT'] = dissemDT;
    data['TimeDiff'] = timeDiff;
    data['Fld_Attachsize'] = fldAttachsize;
    data['ATTACHMENTURL'] = aTTACHMENTURL;
    return data;
  }
}

class Table1 {
  int? rOWCNT;

  Table1({this.rOWCNT});

  Table1.fromJson(Map<String, dynamic> json) {
    rOWCNT = json['ROWCNT'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['ROWCNT'] = rOWCNT;
    return data;
  }
}
