
class ModelCariHereket {

  int? id;
  String? herekttipi;
  String? fakturakodu;
  String? carikod;
  DateTime? createDate;
  double? brutmebleg;
  double? endirimmebleg;
  double? netsatis;
  double? kassa;
  bool? tesdiqleme;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'herekttipi': herekttipi,
      'carikod': carikod,
      'fakturakodu': fakturakodu,
      'createDate': createDate,
      'brutmebleg': brutmebleg,
      'endirimmebleg': endirimmebleg,
      'netsatis': netsatis,
      'kassa': kassa,
      'tesdiqleme': tesdiqleme,
    };
  }

  factory ModelCariHereket.fromJson(Map<dynamic, dynamic> parcedJson) {
    return ModelCariHereket(
      id: parcedJson['id'] ?? "",
      herekttipi: parcedJson['herekttipi'] ?? "",
      fakturakodu: parcedJson['fakturakodu'] ?? "",
      carikod: parcedJson['carikod'] ?? "",
      createDate: parcedJson['createDate'] ?? DateTime.now(),
      brutmebleg: parcedJson['brutmebleg'] ?? 0,
      endirimmebleg: parcedJson['endirimmebleg'] ?? 0,
      netsatis: parcedJson['netsatis'] ?? 0,
      kassa: parcedJson['kassa'] ?? 0,
      tesdiqleme: parcedJson['tesdiqleme'] ?? false,
    );
  }

  ModelCariHereket({
    this.id,
    this.herekttipi,
    this.carikod,
    this.netsatis,
    this.fakturakodu,
    this.createDate,
    this.brutmebleg,
    this.endirimmebleg,
    this.kassa,
    this.tesdiqleme,
  });
}
