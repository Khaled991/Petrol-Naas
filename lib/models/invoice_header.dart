class InoviceHeader {
  String? invno;
  String? invdate;
  String? custName;
  String? total;
  String? discountTotal;
  String? netTotal;
  String? vaTamount;
  String? totAfterVat;

  InoviceHeader({
    this.invno,
    this.invdate,
    this.custName,
    this.total,
    this.discountTotal,
    this.netTotal,
    this.vaTamount,
    this.totAfterVat,
  });

  @override
  String toString() {
    return 'Header(invno: $invno, invdate: $invdate, custName: $custName, total: $total, discountTotal: $discountTotal, netTotal: $netTotal, vaTamount: $vaTamount, totAfterVat: $totAfterVat)';
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
      );

  Map<String, dynamic> toJson() => {
        'invno': invno,
        'invdate': invdate,
        'CustName': custName,
        'total': total,
        'DiscountTotal': discountTotal,
        'netTotal': netTotal,
        'VATamount': vaTamount,
        'TotAfterVAT': totAfterVat,
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
    );
  }
}
