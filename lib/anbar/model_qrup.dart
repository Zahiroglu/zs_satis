class ModelQrupadi{
  int? id;
  String? qrupAdi;
  String? qruphaqqinda;
  int? cesidSayi;
  int? mehsulsayi;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qrupAdi': qrupAdi,
      'qruphaqqinda': qruphaqqinda,
      'cesidSayi': cesidSayi,
      'mehsulsayi': mehsulsayi,
    };
  }

  factory ModelQrupadi.fromJson(Map<dynamic, dynamic> parcedJson) {
    return ModelQrupadi(
      id: parcedJson['id'] ?? 0,
      qrupAdi: parcedJson['qrupAdi'] ?? "",
      qruphaqqinda: parcedJson['qruphaqqinda'] ?? "",
      cesidSayi: parcedJson['cesidSayi'] ?? 0,
      mehsulsayi: parcedJson['mehsulsayi'] ?? 0,
    );
  }

  ModelQrupadi({
    this.id,
    this.qrupAdi,
    this.qruphaqqinda,
    this.cesidSayi,
    this.mehsulsayi,
  });
}