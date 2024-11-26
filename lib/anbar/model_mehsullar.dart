class ModelMehsullar {
  int? id;
  String? mehsulkodu;
  String? qrupAdi;
  String? malinAdi;
  String? malinHaqqinda;
  String? malVahid;
  double? malinQitmeti;
  double? mayaDeyeri;
  double? malinSayi;
  double? malinIlkinqaligi;
  DateTime? createDate;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mehsulkodu': mehsulkodu,
      'qrupAdi': qrupAdi,
      'malinAdi': malinAdi,
      'malinHaqqinda': malinHaqqinda,
      'malVahid': malVahid,
      'mayaDeyeri': mayaDeyeri,
      'malinQitmeti': malinQitmeti,
      'createDate': createDate,
    };
  }

  factory ModelMehsullar.fromJson(Map<dynamic, dynamic> parcedJson) {
    return ModelMehsullar(
      id: parcedJson['id'] ?? "",
      mehsulkodu: parcedJson['mehsulkodu'] ?? "",
      qrupAdi: parcedJson['qrupAdi'] ?? "",
      malinAdi: parcedJson['malinAdi'] ?? "",
      malinHaqqinda: parcedJson['malinHaqqinda'] ?? "",
      malVahid: parcedJson['malVahid'] ?? "",
      mayaDeyeri: parcedJson['mayaDeyeri'] ?? 0,
      malinQitmeti: parcedJson['malinQitmeti'] ?? 0,
      createDate: parcedJson['createDate'] ?? DateTime.now(),
    );
  }

  ModelMehsullar({
    this.id,
    this.mehsulkodu,
    this.qrupAdi,
    this.malinAdi,
    this.malinHaqqinda,
    this.malVahid,
    this.mayaDeyeri,
    this.malinQitmeti,
    this.createDate,
    this.malinSayi,
    this.malinIlkinqaligi,
  });
}
