import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zs_satis/anbar/model_qrup.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';

import 'esas_sehfeanbaranaqrup.dart';
import 'model_mehsullar.dart';
import 'model_stockhereket.dart';
import 'screen_anbarcesid.dart';

class ScreenYeniMehsul extends StatefulWidget {
  String gonderis;
  String anaqrup;
  Function callback;

  ScreenYeniMehsul({Key? key, required this.gonderis, required this.anaqrup,required this.callback})
      : super(key: key);

  @override
  _ScreenYeniMehsulState createState() => _ScreenYeniMehsulState();
}

class _ScreenYeniMehsulState extends State<ScreenYeniMehsul> {
  String selectedAnacari = "Bos";
  String mehsulkodu = "ZS";
  List<String> list_qruplar = [];
  TextEditingController cn_yenimehsulqiymet = TextEditingController();
  TextEditingController cn_yenimehsulqaliq = TextEditingController();
  TextEditingController cn_yenimehsuladi = TextEditingController();
  TextEditingController cn_yenimehsulqeyd = TextEditingController();
  TextEditingController cn_yenimehsulmayadeyer = TextEditingController();
  bool _validate_ad = false;
  bool _validate_qaliq = false;
  bool _validate_qiymet = false;
  bool _validate_mayadeyer = false;
  String selectedvahid = "";
  bool melumattapildi = false;
  bool anaqruplarvar = false;

  getlastidFromMehsullar() async {
    int? reqem = await SqlDatabase.db.getLasMehsulId();
    setState(() {
      mehsulkodu = "ZS00" + reqem.toString();
    });
  }

  Future _checkIfExist(ModelMehsullar modelMehsullar) async {
    int? say = await SqlDatabase.db
        .getMalCountByMalAdi(modelMehsullar.malinAdi.toString());
    if (say == 0) {
      _melumatidaxilet(modelMehsullar);
    } else {
      Fluttertoast.showToast(
              msg: "Eyni adda mehsul yarada bilmezsiz",
              toastLength: Toast.LENGTH_LONG)
          .then((value) => {
                setState(() {
                  cn_yenimehsuladi.clear();
                })
              });
    }
  }

  Future _melumatidaxilet(ModelMehsullar modelMehsullar) async {
    await SqlDatabase.db.addAnbarMehsulToDb(modelMehsullar).whenComplete(() => {
      _saveStocksayiTodb(modelMehsullar),
        });
  }

  void _saveStocksayiTodb(ModelMehsullar modelMehsullar) async{
    ModelStockHereket modelhereket=ModelStockHereket(
      cixissayi: 0,
      groupid: modelMehsullar.qrupAdi,
        mehsulkodu: modelMehsullar.mehsulkodu,
      createDate: DateTime.now(),
      gisirsayi: modelMehsullar.malinSayi,
      herekettipi: "0",
      musterikodu: "bos",
      ilkinqaliq: 0,
      sonqaliq: modelMehsullar.malinSayi,
    );
    await SqlDatabase.db.addStockHerekerToDb(modelhereket).whenComplete(() => {
      Fluttertoast.showToast(msg: "Melumat ugurla daxil edildi.", toastLength: Toast.LENGTH_LONG),
      if (widget.gonderis == "meh")
        {
          Navigator.pop(context),widget.callback.call(),
        }
      else
        {
          Navigator.pop(context),widget.callback.call(),
        }
    });


  }


  @override
  void dispose() {
    cn_yenimehsulqiymet.dispose();
    cn_yenimehsulqaliq.dispose();
    cn_yenimehsuladi.dispose();
    cn_yenimehsulqeyd.dispose();
    cn_yenimehsulmayadeyer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    SqlDatabase.db.init();
    _anaqruplariGetir();
    getlastidFromMehsullar();
    // TODO: implement initState
    super.initState();
  }

  _anaqruplariGetir() async {
    list_qruplar.clear();
    await SqlDatabase.db.getAllAnaQruplar().then((value) => {
          if (value.isNotEmpty)
            {
              value.forEach((element) {
                setState(() {
                  list_qruplar.add(element.id.toString()+" | "+element.qrupAdi.toString());
                  melumattapildi = true;
                  anaqruplarvar=true;
                });
              })
            }
          else
            {melumattapildi = true,
              anaqruplarvar=false
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            "Yeni mehsul elave et".toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: melumattapildi
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text("genereted id:"+mehsulkodu,textAlign: TextAlign.left,),
                      ),
                      DropdownSearch<String>(
                          mode: Mode.MENU,
                          items: list_qruplar,
                          label: "ANA QRUP",
                          popupItemDisabled: (String s) => s.startsWith('I'),
                          onChanged: (value) {
                            int idx = value!.indexOf(" |");
                            String parts = value.substring(0,idx).trim();
                            selectedAnacari = parts.toString();
                            print("selected id :"+parts);
                          },
                          selectedItem: "Qrup sec"),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<String>(
                          mode: Mode.MENU,
                          items: const [
                            "ƏDƏD",
                            "QUTU",
                            "KQ",
                            "KİSƏ",
                            "CÜT",
                          ],
                          label: "Vahid tipi",
                          popupItemDisabled: (String s) => s.startsWith('I'),
                          onChanged: (value) {
                            selectedvahid = value.toString();
                          },
                          selectedItem: "Tip seç"),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(fontSize: SizeConfig.textsize16SP),
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          errorText: _validate_ad ? "Xanani doldurun!" : null,
                          labelStyle: TextStyle(
                              fontSize: SizeConfig.textsize18SP,
                              color: Colors.green),
                          labelText: "Məhsul adı",
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          border: InputBorder.none,
                        ),
                        controller: cn_yenimehsuladi,
                      ), //Mehsulun adi
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(fontSize: SizeConfig.textsize16SP),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          errorText:
                              _validate_mayadeyer ? "Xanani doldurun!" : null,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          labelStyle: TextStyle(
                              fontSize: SizeConfig.textsize18SP,
                              color: Colors.green),
                          labelText: "Maya Deyeri",
                          border: InputBorder.none,
                        ),
                        controller: cn_yenimehsulmayadeyer,
                      ), //mehsulun maya deyeri
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(fontSize: SizeConfig.textsize16SP),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          errorText:
                              _validate_qiymet ? "Xanani doldurun!" : null,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          labelStyle: TextStyle(
                              fontSize: SizeConfig.textsize18SP,
                              color: Colors.green),
                          labelText: "Qəymət",
                          border: InputBorder.none,
                        ),
                        controller: cn_yenimehsulqiymet,
                      ), //mehsulun qitmeti
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(fontSize: SizeConfig.textsize16SP),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          errorText:
                              _validate_qaliq ? "Xanani doldurun!" : null,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          labelStyle: TextStyle(
                              fontSize: SizeConfig.textsize18SP,
                              color: Colors.green),
                          labelText: "Stock sayı",
                          border: InputBorder.none,
                        ),
                        controller: cn_yenimehsulqaliq,
                      ), //stock sayi
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(fontSize: SizeConfig.textsize16SP),
                        maxLines: 3,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          labelStyle: TextStyle(
                              fontSize: SizeConfig.textsize18SP,
                              color: Colors.green),
                          labelText: "Qeyd",
                          border: InputBorder.none,
                        ),
                        controller: cn_yenimehsulqeyd,
                      ), //qeyd
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (cn_yenimehsuladi.text.isNotEmpty ||
                                cn_yenimehsulqaliq.text.isNotEmpty ||
                                cn_yenimehsulqiymet.text.isNotEmpty ||
                                selectedAnacari.isNotEmpty ||
                                selectedvahid.isNotEmpty ||
                                cn_yenimehsulmayadeyer.text.isNotEmpty) {
                              ModelMehsullar model = ModelMehsullar(
                                mehsulkodu: mehsulkodu,
                                  malinHaqqinda: cn_yenimehsulqeyd.text,
                                  qrupAdi: selectedAnacari,
                                  malinSayi: double.parse(
                                      cn_yenimehsulqaliq.text.toString()),
                                  malinAdi: cn_yenimehsuladi.text,
                                  malinQitmeti: double.parse(
                                      cn_yenimehsulqiymet.text.toString()),
                                  malVahid: selectedvahid,
                                  mayaDeyeri: double.parse(
                                      cn_yenimehsulmayadeyer.text.toString()));
                              _checkIfExist(model);
                            } else {
                              cn_yenimehsulqiymet.text.isEmpty
                                  ? _validate_qiymet = true
                                  : _validate_qiymet = false;
                              cn_yenimehsulmayadeyer.text.isEmpty
                                  ? _validate_mayadeyer = true
                                  : _validate_mayadeyer = false;
                              cn_yenimehsuladi.text.isEmpty
                                  ? _validate_ad = true
                                  : _validate_ad = false;
                              cn_yenimehsulqaliq.text.isEmpty
                                  ? _validate_qaliq = true
                                  : _validate_qaliq = false;
                              setState(() {});
                            }
                          },
                          child: Text("Daxil et"))
                    ],
                  )
                : SpinKitCircle(
                    color: Colors.green,
                  ),
          ),
        ),
      ),
    );
  }
}
