class ModelUser {
  String? id;
  String? username;
  String? telefonnom;
  String? companiname;
  String? vezife;
  String? qeydiyyattarixi;
  String? sonaktivlik;
  bool? istifadehuququ;
  bool? satisscreengorsun;
  bool? satisedebilsin;
  bool? stockscreengorsun;
  bool? yenimehsulyaratsin;
  bool? caneditstock;
  bool? canseemusterilerscreen;
  bool? cancreatemusteri;
  bool? canseehesabatscreen;
  bool? canseecarihereketrapor;
  bool? canseestockhereketrapor;
  bool? canseesatishereketrapor;
  bool? canseeprofilscreen;
  bool? caneditprofil;
  bool? downloadedebilsin;
  bool? syncedebilsin;
  bool? userlogged;

  ModelUser({
    this.id,
    this.username,
    this.telefonnom,
    this.companiname,
    this.vezife,
    this.qeydiyyattarixi,
    this.sonaktivlik,
    this.istifadehuququ,
    this.satisscreengorsun,
    this.satisedebilsin,
    this.stockscreengorsun,
    this.yenimehsulyaratsin,
    this.caneditstock,
    this.canseemusterilerscreen,
    this.cancreatemusteri,
    this.canseehesabatscreen,
    this.canseecarihereketrapor,
    this.canseestockhereketrapor,
    this.canseesatishereketrapor,
    this.canseeprofilscreen,
    this.caneditprofil,
    this.downloadedebilsin,
    this.syncedebilsin,
    this.userlogged,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'companiname': companiname,
      'vezife': vezife,
      'qeydiyyattarixi': qeydiyyattarixi,
      'sonaktivlik': sonaktivlik,
      'istifadehuququ': istifadehuququ,
      'satisscreengorsun': satisscreengorsun,
      'satisedebilsin': satisedebilsin,
      'stockscreengorsun': stockscreengorsun,
      'yenimehsulyaratsin': yenimehsulyaratsin,
      'caneditstock': caneditstock,
      'canseemusterilerscreen': canseemusterilerscreen,
      'cancreatemusteri': cancreatemusteri,
      'canseehesabatscreen': canseehesabatscreen,
      'canseecarihereketrapor': canseecarihereketrapor,
      'canseestockhereketrapor': canseestockhereketrapor,
      'canseesatishereketrapor': canseesatishereketrapor,
      'canseeprofilscreen': canseeprofilscreen,
      'caneditprofil': caneditprofil,
      'downloadedebilsin': downloadedebilsin,
      'syncedebilsin': syncedebilsin,
      'userlogged': userlogged,
    };
  }

  factory ModelUser.fromJson(Map<dynamic, dynamic> parcedJson) {
    return ModelUser(
      id: parcedJson['id'] ?? 0,
      username: parcedJson['username'] ?? "",
      companiname: parcedJson['companiname'] ?? "",
      vezife: parcedJson['vezife'] ?? "0",
      qeydiyyattarixi: parcedJson['qeydiyyattarixi'] ?? DateTime.now().toIso8601String(),
      sonaktivlik: parcedJson['sonaktivlik'] ?? DateTime.now().toIso8601String(),
      istifadehuququ: parcedJson['istifadehuququ'] ?? false,
      satisscreengorsun: parcedJson['satisscreengorsun'] ?? false,
      satisedebilsin: parcedJson['satisedebilsin'] ?? false,
      stockscreengorsun: parcedJson['stockscreengorsun'] ?? false,
      yenimehsulyaratsin: parcedJson['yenimehsulyaratsin'] ?? false,
      caneditstock: parcedJson['caneditstock'] ?? false,
      canseemusterilerscreen: parcedJson['canseemusterilerscreen'] ?? false,
      cancreatemusteri: parcedJson['cancreatemusteri'] ?? false,
      canseehesabatscreen: parcedJson['canseehesabatscreen'] ?? false,
      canseecarihereketrapor: parcedJson['canseecarihereketrapor'] ?? false,
      canseestockhereketrapor: parcedJson['canseestockhereketrapor'] ?? false,
      canseesatishereketrapor: parcedJson['canseesatishereketrapor'] ?? false,
      canseeprofilscreen: parcedJson['canseeprofilscreen'] ?? false,
      caneditprofil: parcedJson['caneditprofil'] ?? false,
      downloadedebilsin: parcedJson['downloadedebilsin'] ?? false,
      syncedebilsin: parcedJson['syncedebilsin'] ?? false,
      userlogged: parcedJson['userlogged'] ?? false,
    );
  }
}
