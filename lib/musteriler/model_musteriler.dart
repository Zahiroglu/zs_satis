class ModelMusteriler {
  int? id;
  String? carikod;
  String? musteriadi;
  String? tamunvan;
  String? mesulsexs;
  String? telefon;
  String? kodrdinatlar;
  DateTime? qeydiyyattarixi;
  DateTime? lastupdateday;
  String? qeyd;
  bool isclecked=false;
  double? umumisatis;
  double? umumiodeme;
  double? umumiendirim;
  double? umumiqaliq;
  double? umumixeyir;
  double? sonborc;
  double? ilkinborc;

  factory ModelMusteriler.fromJson(Map<dynamic, dynamic> parcedJson) {
    return ModelMusteriler(
      id: parcedJson['id'] ?? 0,
      carikod: parcedJson['carikod'] ?? "Bos",
      musteriadi: parcedJson['musteriadi'] ?? "Bos",
      tamunvan: parcedJson['tamunvan'] ?? "Bos",
      mesulsexs: parcedJson['mesulsexs'] ?? "Bos",
      telefon: parcedJson['telefon'] ?? "Bos",
      kodrdinatlar: parcedJson['kodrdinatlar'] ?? "Bos",
      qeydiyyattarixi: parcedJson['qeydiyyattarixi'] ?? DateTime.now(),
      lastupdateday: parcedJson['lastupdateday'] ?? DateTime.now(),
      qeyd: parcedJson['qeyd'] ?? "Bos",
      isclecked: parcedJson['isclecked'] ?? false,
      umumisatis: parcedJson['umumisatis'] ?? 0,
      umumiodeme: parcedJson['umumiodeme'] ?? 0,
      umumiendirim: parcedJson['umumiendirim'] ?? 0,
      umumiqaliq: parcedJson['umumiqaliq'] ?? 0,
      umumixeyir: parcedJson['umumixeyir'] ?? 0,
      sonborc: parcedJson['sonborc'] ?? 0,
      ilkinborc: parcedJson['ilkinborc'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carikod': carikod,
      'musteriadi': musteriadi,
      'tamunvan': tamunvan,
      'mesulsexs': mesulsexs,
      'telefon': telefon,
      'kodrdinatlar': kodrdinatlar,
      'qeydiyyattarixi': qeydiyyattarixi,
      'lastupdateday': lastupdateday,
      'qeyd': qeyd,
      'isclecked': isclecked,
      'umumisatis': umumisatis,
      'umumiodeme': umumiodeme,
      'umumiendirim': umumiendirim,
      'umumiqaliq': umumiqaliq,
      'umumixeyir': umumixeyir,
      'sonborc': sonborc,
      'ilkinborc': ilkinborc,
    };
  }

  ModelMusteriler({
    this.id,
    this.carikod,
    this.musteriadi,
    this.tamunvan,
    this.mesulsexs,
    this.telefon,
    this.kodrdinatlar,
    this.qeydiyyattarixi,
    this.lastupdateday,
    this.qeyd,
    required this.isclecked,
    this.umumisatis,
    this.umumiodeme,
    this.umumiendirim,
    this.umumiqaliq,
    this.umumixeyir,
    this.sonborc,
    this.ilkinborc,
  });
}

