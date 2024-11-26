class ModelSatis {
  int? id;
  String? fakturanomresi;
  String? groupid;
  String? mehsulkodu;
  String? mehsuladi;
  String? mustericarikodu;
  DateTime? vaxt;
  double? ilkinstoksayi;
  double? sonstoksayi;
  double? satismiqdari;
  double? satissumma;
  double? netsatis;
  double? satisendirim;
  double? satisxeyir;
  bool? negdSayis;
  bool? tesdiqleme;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fakturanomresi': fakturanomresi,
      'groupid': groupid,
      'mehsulkodu': mehsulkodu,
      'mehsuladi': mehsuladi,
      'mustericarikodu': mustericarikodu,
      'vaxt': vaxt,
      'satismiqdari': satismiqdari,
      'netsatis': netsatis,
      'satissumma': satissumma,
      'satisendirim': satisendirim,
      'satisxeyir': satisxeyir,
      'negdSayis': negdSayis,
      'tesdiqleme': tesdiqleme,
    };
  }

  factory ModelSatis.fromJson(Map<dynamic, dynamic> parcedJson) {
    return ModelSatis(
      id: parcedJson['id'] ?? "",
      fakturanomresi: parcedJson['fakturanomresi'] ?? "",
      groupid: parcedJson['groupid'] ?? "",
      mehsulkodu: parcedJson['mehsulkodu'] ?? "",
      mehsuladi: parcedJson['mehsuladi'] ?? "",
      mustericarikodu: parcedJson['mustericarikodu'] ?? "",
      vaxt: parcedJson['vaxt'] ?? "",
      satismiqdari: parcedJson['satismiqdari'] ?? 0,
      netsatis: parcedJson['netsatis'] ?? 0,
      satissumma: parcedJson['satissumma'] ?? 0,
      satisendirim: parcedJson['satisendirim'] ?? 0,
      satisxeyir: parcedJson['satisxeyir'] ?? 0,
      negdSayis: parcedJson['negdSayis'] ?? false,
      tesdiqleme: parcedJson['tesdiqleme'] ?? false,
    );
  }

  ModelSatis({
    this.id,
    this.fakturanomresi,
    this.groupid,
    this.mehsulkodu,
    this.mehsuladi,
    this.mustericarikodu,
    this.vaxt,
    this.ilkinstoksayi,
    this.sonstoksayi,
    this.satismiqdari,
    this.netsatis,
    this.satisendirim,
    this.satissumma,
    this.satisxeyir,
    this.negdSayis,
    this.tesdiqleme,
  });
}
