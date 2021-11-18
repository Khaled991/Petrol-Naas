class Receipt {
  String? recNo;
  int? branchno;
  double? amount;
  String? description;
  String? recAccno;
  int? recType;
  int? posted;
  int? saleInvNo;
  String? createdDate;
  String? accNo;
  String? accName;
  String? accYear;
  String? paidType;
  String? costCenterno;

  Receipt({
    this.recNo,
    this.branchno,
    this.amount,
    this.description,
    this.recAccno,
    this.recType,
    this.posted,
    this.saleInvNo,
    this.createdDate,
    this.accNo,
    this.accName,
    this.accYear,
    this.paidType,
    this.costCenterno,
  });

  @override
  String toString() {
    return 'Receipt(recNo: $recNo, branchno: $branchno, amount: $amount, description: $description, recAccno: $recAccno, recType: $recType, posted: $posted, saleInvNo: $saleInvNo, createdDate: $createdDate, accNo: $accNo, accName: $accName, accYear: $accYear, paidType: $paidType, costCenterno: $costCenterno)';
  }

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
        recNo: json['RecNo'] as String?,
        branchno: json['Branchno'] as int?,
        amount: double.parse(json['Amount'].toString()),
        description: json['Description'] as String?,
        recAccno: json['RecAccno'] as String?,
        recType: json['RecType'] as int?,
        posted: json['Posted'] as int?,
        saleInvNo: json['SaleInvNo'] as int?,
        createdDate: json['CreatedDate'] as String?,
        accNo: json['AccNo'] as String?,
        accName: json['AccName'] as String?,
        accYear: json['AccYear'] as String?,
        paidType: json['PaidType'] as String?,
        costCenterno: json['CostCenterno'] as String?,
      );

  static List<Receipt> fromJsonList(List<dynamic> jsonList) =>
      List<Receipt>.from(jsonList.map((receipt) => Receipt.fromJson(receipt)));

  Map<String, dynamic> toJson() => {
        'RecNo': recNo,
        'Branchno': branchno,
        'Amount': amount,
        'Description': description,
        'RecAccno': recAccno,
        'RecType': recType,
        'Posted': posted,
        'SaleInvNo': saleInvNo,
        'CreatedDate': createdDate,
        'AccNo': accNo,
        'AccName': accName,
        'AccYear': accYear,
        'PaidType': paidType,
        'CostCenterno': costCenterno,
      };

  Receipt copyWith({
    String? recNo,
    int? branchno,
    double? amount,
    String? description,
    String? recAccno,
    int? recType,
    int? posted,
    int? saleInvNo,
    String? createdDate,
    String? accNo,
    String? accName,
    String? accYear,
    String? paidType,
    String? costCenterno,
  }) {
    return Receipt(
      recNo: recNo ?? this.recNo,
      branchno: branchno ?? this.branchno,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      recAccno: recAccno ?? this.recAccno,
      recType: recType ?? this.recType,
      posted: posted ?? this.posted,
      saleInvNo: saleInvNo ?? this.saleInvNo,
      createdDate: createdDate ?? this.createdDate,
      accNo: accNo ?? this.accNo,
      accName: accName ?? this.accName,
      accYear: accYear ?? this.accYear,
      paidType: paidType ?? this.paidType,
      costCenterno: costCenterno ?? this.costCenterno,
    );
  }
}
