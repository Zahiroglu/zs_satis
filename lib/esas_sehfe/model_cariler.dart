class ModelCariler {
  int? id;
  String? carikod;
  String? cariad;
  String? tamun;
  String? mehsulsexs;
  String? telefon;
  String? sticker;
  String? sahe;
  String? kateqoriya;
  String? bolgekodu;
  String? expkodu;
  String? gpsuzunluq;
  String? gpseynilik;
  String? voun;
  String? qaliq;
  String? rayon;
  String? gbir;
  String? giki;
  String? guc;
  String? gdort;
  String? gbes;
  String? galti;
  String? ziyaret;
  String? gonderis;
  String? gbagli;
  String? hereket;
  String? anaCari;
  String? girisEdildi;
  double? distance;

  factory ModelCariler.fromJson(Map<dynamic, dynamic> parcedJson) {
    return ModelCariler(
      carikod: parcedJson['carikod'] ?? "Bos",
      cariad: parcedJson['cariad'] ?? "Bos",
      tamun: parcedJson['tamun'] ?? "Bos",
      mehsulsexs: parcedJson['mehsulsexs'] ?? "Bos",
      telefon: parcedJson['telefon'] ?? "Bos",
      sticker: parcedJson['sticker'] ?? "Bos",
      sahe: parcedJson['sahe'] ?? "Bos",
      kateqoriya: parcedJson['kateqoriya'] ?? "Bos",
      bolgekodu: parcedJson['bolgekodu'] ?? "Bos",
      expkodu: parcedJson['expkodu'] ?? "Bos",
      gpsuzunluq: parcedJson['gpsuzunluq'] ?? "Bos",
      gpseynilik: parcedJson['gpseynilik'] ?? "Bos",
      voun: parcedJson['voun'] ?? "Bos",
      qaliq: parcedJson['qaliq'] ?? "Bos",
      gbir: parcedJson['gbir'] ?? "Bos",
      giki: parcedJson['giki'] ?? "Bos",
      guc: parcedJson['guc'] ?? "Bos",
      gdort: parcedJson['gdort'] ?? "Bos",
      gbes: parcedJson['gbes'] ?? "Bos",
      galti: parcedJson['galti'] ?? "Bos",
      ziyaret: parcedJson['ziyaret'] ?? "Bos",
      gonderis: parcedJson['gonderis'] ?? "Bos",
      gbagli: parcedJson['gbagli'] ?? "Bos",
      hereket: parcedJson['h1'] ?? "Bos",
      anaCari: parcedJson['anaCari'] ?? "Bos",
      girisEdildi: parcedJson['girisEdildi'] ?? "Bos",
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'carikod': carikod,
      'cariad': cariad,
      'tamun': tamun,
      'mehsulsexs': mehsulsexs,
      'telefon': telefon,
      'sticker': sticker,
      'sahe': sahe,
      'kateqoriya': kateqoriya,
      'bolgekodu': bolgekodu,
      'expkodu': expkodu,
      'gpsuzunluq': gpsuzunluq,
      'gpseynilik': gpseynilik,
      'voun': voun,
      'qaliq': qaliq,
      'rayon': rayon,
      'gbir': gbir,
      'giki': giki,
      'guc': guc,
      'gdort': gdort,
      'gbes': gbes,
      'galti': galti,
      'ziyaret': ziyaret,
      'gonderis': gonderis,
      'gbagli': gbagli,
      'h1': hereket,
      'anaCari': anaCari,
      'girisEdildi': girisEdildi,
    };
  }

  ModelCariler(
      {this.id,
      this.carikod,
      this.cariad,
      this.tamun,
      this.mehsulsexs,
      this.telefon,
      this.sticker,
      this.sahe,
      this.kateqoriya,
      this.bolgekodu,
      this.expkodu,
      this.gpsuzunluq,
      this.gpseynilik,
      this.voun,
      this.qaliq,
      this.rayon,
      this.gbir,
      this.giki,
      this.guc,
      this.gdort,
      this.gbes,
      this.galti,
      this.ziyaret,
      this.gonderis,
      this.gbagli,
      this.hereket,
      this.anaCari,
      this.girisEdildi,
      this.distance});
}
