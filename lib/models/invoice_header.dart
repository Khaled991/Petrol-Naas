class InoviceHeader {
  String? invno;
  String? invdate;
  String? custName;
  String? total;
  String? discountTotal;
  String? netTotal;
  String? vaTamount;
  String? totAfterVat;
  String? createdDelegateName;
  String? payType;

  InoviceHeader({
    this.invno,
    this.invdate,
    this.custName,
    this.total,
    this.discountTotal,
    this.netTotal,
    this.vaTamount,
    this.totAfterVat,
    this.createdDelegateName,
    this.payType,
  });

  @override
  String toString() {
    return 'Header(invno: $invno, invdate: $invdate, custName: $custName, total: $total, discountTotal: $discountTotal, netTotal: $netTotal, vaTamount: $vaTamount, totAfterVat: $totAfterVat, createdDelegateName: $createdDelegateName), payType: $payType)';
  }

  factory InoviceHeader.fromJson(Map<String, dynamic> json) => InoviceHeader(
        invno: json['invno'] as String?,
        invdate: json['invdate'] as String?,
        custName: json['CustName'] as String?,
        total: json['total'] as String?,
        discountTotal: json['DiscountTotal'] as String?,
        netTotal: json['netTotal'] as String?,
        vaTamount: json['VATamount'] as String?,
        totAfterVat: json['TotAfterVAT'] as String?,
        createdDelegateName: json['User_Name'] as String?,
        payType: decodePayType(json['PayType'] as String?),
      );

  static String? decodePayType(String? payType) {
    Map<String, String> payTypeDecode = {
      "1": "نقدي كاش",
      "3": "آجل",
    };
    return payTypeDecode[payType];
  }

  static String? encodePayType(String? payTypeText) {
    Map<String, String> payTypeEncode = {
      "نقدي كاش": "1",
      "آجل": "3",
    };
    return payTypeEncode[payTypeText];
  }

  Map<String, dynamic> toJson() => {
        'invno': invno,
        'invdate': invdate,
        'CustName': custName,
        'total': total,
        'DiscountTotal': discountTotal,
        'netTotal': netTotal,
        'VATamount': vaTamount,
        'TotAfterVAT': totAfterVat,
        'User_Name': createdDelegateName,
        'PayType': payType,
      };

  InoviceHeader copyWith({
    String? invno,
    String? invdate,
    String? custName,
    String? total,
    String? discountTotal,
    String? netTotal,
    String? vaTamount,
    String? totAfterVat,
    String? userName,
    String? payType,
  }) {
    return InoviceHeader(
      invno: invno ?? this.invno,
      invdate: invdate ?? this.invdate,
      custName: custName ?? this.custName,
      total: total ?? this.total,
      discountTotal: discountTotal ?? this.discountTotal,
      netTotal: netTotal ?? this.netTotal,
      vaTamount: vaTamount ?? this.vaTamount,
      totAfterVat: totAfterVat ?? this.totAfterVat,
      createdDelegateName: userName ?? createdDelegateName,
      payType: payType ?? this.payType,
    );
  }
}
