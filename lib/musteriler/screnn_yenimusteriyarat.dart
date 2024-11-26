import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/anbar/model_stockhereket.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/esas_sehfe/model_cariler.dart';
import 'package:zs_satis/musteriler/model_musteriler.dart';

class ScreenYeniMusteriYarat extends StatefulWidget {
  Function callToRefresh;

  ScreenYeniMusteriYarat({Key? key, required this.callToRefresh})
      : super(key: key);

  @override
  _ScreenYeniMusteriYaratState createState() => _ScreenYeniMusteriYaratState();
}

class _ScreenYeniMusteriYaratState extends State<ScreenYeniMusteriYarat> {
  String carikod = "1000";
  ModelMusteriler? modelMusteriler;
  DateTime? bugun;
  TextEditingController cn_marketadi = TextEditingController();
  TextEditingController cn_mesulsexs = TextEditingController();
  TextEditingController cn_telefon = TextEditingController();
  TextEditingController cn_tamunvan = TextEditingController();
  TextEditingController cn_gpskordinat = TextEditingController();
  TextEditingController cn_qeyd = TextEditingController();

  @override
  void initState() {
    SqlDatabase.db.init();
    getlastidFromMusteriler();
    getlastDate();
    // TODO: implement initState
    super.initState();
  }


  getlastDate() {
    bugun = DateTime.now();
  }

  getlastidFromMusteriler() async {
    int? reqem = await SqlDatabase.db.getLasMusteriId();
    setState(() {
      carikod = "ZS00" + reqem.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                ModelMusteriler model = ModelMusteriler(
                    isclecked: false,
                    carikod: carikod.toString(),
                    musteriadi: cn_marketadi.text,
                    mesulsexs: cn_mesulsexs.text,
                    telefon: cn_telefon.text,
                    tamunvan: cn_tamunvan.text,
                    kodrdinatlar: cn_gpskordinat.text,
                    qeydiyyattarixi: bugun,
                    qeyd: cn_qeyd.text);
                _saveMusteriToDB(model);
              },
              child: Container(
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Əlavə et"),
                  )),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: true,
        title: Text("Yeni musteri"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "id :" + carikod.toString(),
                  style: GoogleFonts.teko(
                      color: Colors.black87, fontSize: SizeConfig.textsize18SP),
                ),
                Text(
                  "Qeydiyyat Tarixi :" + bugun.toString().substring(0, 16),
                  style: GoogleFonts.teko(
                      color: Colors.black87, fontSize: SizeConfig.textsize18SP),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.green,
                  controller: cn_marketadi,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelText: "Market adı *",
                      labelStyle: TextStyle(color: Colors.red),
                      hintText: "Market adini daxil edin...",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.green))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.green,
                  controller: cn_mesulsexs,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelText: "Mesul shexs *",
                      labelStyle: TextStyle(color: Colors.red),
                      hintText: "Mesul shexs adini daxil edin",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.green))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.green,
                  controller: cn_telefon,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelText: "Telefon nomresi *",
                      labelStyle: TextStyle(color: Colors.red),
                      hintText: "Telefon nomresi daxil edin",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.green))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.green,
                  controller: cn_tamunvan,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelText: "Tam unvan ",
                      hintText: "Tam unvan daxil edin",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.green))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.green,
                  controller: cn_gpskordinat,
                  decoration: InputDecoration(
                      helperText: "Misal: 40.45857852,49.51525166",
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelText: "GPS kordinatlar ",
                      hintText: "Gps daxil edin",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.green))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLines: 4,
                  minLines: 2,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.green,
                  controller: cn_qeyd,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelText: "Qeyd ",
                      hintText: "Qeyd daxil edin",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.green))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveMusteriToDB(ModelMusteriler model) async {
    await SqlDatabase.db.addMusteritoDb(model).whenComplete(() => {
    Navigator.pop(context),
    widget.callToRefresh.call(),
        Fluttertoast.showToast(msg: "Ugurla elave edildi")
  });
  }

}
