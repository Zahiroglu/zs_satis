class ModelStockHereket {
  int? id;
  DateTime? createDate;
  String? herekettipi;
  String? groupid;
  String? mehsulkodu;
  String? musterikodu;
  double? cixissayi;
  double? gisirsayi;
  double? ilkinqaliq;
  double? sonqaliq;
  bool? tesdiqlenme;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createDate': createDate,
      'herekettipi': herekettipi,
      'groupid': groupid,
      'mehsulkodu': mehsulkodu,
      'musterikodu': musterikodu,
      'cixissayi': cixissayi,
      'gisirsayi': gisirsayi,
      'ilkinqaliq': ilkinqaliq,
      'sonqaliq': sonqaliq,
      'tesdiqlenme': tesdiqlenme,
    };
  }

  factory ModelStockHereket.fromJson(Map<dynamic, dynamic> parcedJson) {
    return ModelStockHereket(
      id: parcedJson['id'] ?? "",
      createDate: parcedJson['createDate'] ?? DateTime.now(),
      herekettipi: parcedJson['herekettipi'] ?? "",
      groupid: parcedJson['groupid'] ?? "",
      mehsulkodu: parcedJson['mehsulkodu'] ?? "",
      musterikodu: parcedJson['musterikodu'] ?? "",
      cixissayi: parcedJson['cixissayi'] ?? 0,
      gisirsayi: parcedJson['gisirsayi'] ?? 0,
      ilkinqaliq: parcedJson['ilkinqaliq'] ?? 0,
      sonqaliq: parcedJson['sonqaliq'] ?? 0,
      tesdiqlenme: parcedJson['tesdiqlenme'] ?? 0,

    );
  }

  ModelStockHereket({
    this.id,
    this.createDate,
    this.herekettipi,
    this.groupid,
    this.mehsulkodu,
    this.musterikodu,
    this.cixissayi,
    this.gisirsayi,
    this.ilkinqaliq,
    this.sonqaliq,
    this.tesdiqlenme,
  });
}
