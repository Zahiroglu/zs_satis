
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zs_satis/anbar/model_mehsullar.dart';
import 'package:zs_satis/anbar/model_qrup.dart';
import 'package:zs_satis/anbar/widget_stockartir.dart';
import 'package:zs_satis/constandlar/app_theme.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';

import 'esas_sehfeanbaranaqrup.dart';
import 'screen_yenimehsul.dart';

class ScreenAnbarCesid extends StatefulWidget {
  Function callBack;
  String anaqrup;

  ScreenAnbarCesid({Key? key, required this.anaqrup,required this.callBack}) : super(key: key);

  @override
  _ScreenAnbarCesidState createState() => _ScreenAnbarCesidState();
}

class _ScreenAnbarCesidState extends State<ScreenAnbarCesid> {
  bool isloading = false;
  List<ModelMehsullar> list_mallar = [];
  List<String> list_qruplar = [];
  late bool ishover = false;
  late bool daxiledildi = false;

  @override
  void initState() {
    print("Gelen ana qrup :" + widget.anaqrup);
    SqlDatabase.db.init();
    getDataFromDp();
    getDataFromDpAnaqrup();
    // TODO: implement initState
    super.initState();
  }

  Future getDataFromDp() async {
    list_mallar.clear();
    await SqlDatabase.db.getAllMallarByAnaQrup(widget.anaqrup).then((value) => {
          value.forEach((element) {
            list_mallar.add(element);
            print("Mal adi ;" + element.malinAdi.toString());
            print("AnaQrup ;" + element.qrupAdi.toString());
          })
        });
    setState(() {});
  }

  Future getDataFromDpAnaqrup() async {
    await SqlDatabase.db.getAllAnaQruplar().then((value) => {
          value.forEach((element) {
            list_qruplar.add(element.qrupAdi.toString());
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      child: SafeArea(
        child: buildContainer_mobile(context),
      ),
    );
  }

  Container buildContainer_mobile(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: SizeConfig.screenHeight! * 0.08,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.zero),
                gradient: AppTheme.bacgroundgradient,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 5),
                ]),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.callBack.call();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(const Radius.circular(20)),
                    ),
                    margin: const EdgeInsets.only(
                        left: 1, top: 10, bottom: 10, right: 10),
                    alignment: Alignment.center,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: const Icon(Icons.search),
                        hintText: Shablomsozler().axtarisedin,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          customButton(context, "Yeni Məhsul yarat", Icons.add, 0.9),
          const SizedBox(
            height: 5,
          ),
          isloading
              ? const Center(
                  child: SpinKitCircle(
                    color: Colors.green,
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: list_mallar.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.transparent,
                          child: _customItems(list_mallar.elementAt(index)),
                        );
                      }),
                ),
        ],
      ),
    );
  }

  Widget _customItems(ModelMehsullar model) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
            )
          ]),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    model.malinAdi.toString().toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.textsize18SP,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showEdilMehsulDialog(context, model);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.green,
                    )),
              ],
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Malın qiyməti : " +
                            model.malinQitmeti.toString() +
                            " ₼",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.textsize14SP,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Malın stok sayı : " +
                            model.malinSayi.toString() +
                            " " +
                            model.malVahid.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.textsize14SP,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScreenStockArtiq(
                      callBack: () {
                        callBack();
                      },
                      modelmehsul: model,
                    )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26, width: 2)),
                      width: SizeConfig.screenWidth! * 0.2,
                      height: SizeConfig.screenHeight! * 0.08,
                      child: Center(
                          child: Text(
                        "STOCK ARTIR",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: SizeConfig.textsize14SP),
                      )),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Qeyd : " + model.malinHaqqinda.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.textsize12SP,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEdilMehsulDialog(BuildContext context, ModelMehsullar model) {
    TextEditingController controllerQrupadia = TextEditingController();
    TextEditingController controllerQrupadi = TextEditingController();
    TextEditingController controllerQrupqeyd = TextEditingController();
    TextEditingController controllerqiymet = TextEditingController();
    controllerQrupadia.text = model.qrupAdi.toString();
    controllerQrupadi.text = model.malinAdi.toString();
    controllerQrupqeyd.text = model.malinHaqqinda.toString();
    controllerqiymet.text = model.malinQitmeti.toString();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            child: Container(
              height: SizeConfig.widgethundurluk06!,
              padding: const EdgeInsets.only(
                  left: 10, top: 10, right: 10, bottom: 5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 5),
                        blurRadius: 5),
                  ]),
              child: Column(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.green,
                    size: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      "Məhsul məlumatı dəyişdirilməsi",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                    indent: 5,
                    color: Colors.grey,
                    height: 1,
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                                mode: Mode.MENU,
                                items: list_qruplar,
                                label: "ANA QRUP",
                                popupItemDisabled: (String s) =>
                                    s.startsWith('I'),
                                onChanged: print,
                                selectedItem: controllerQrupadia.text),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 1),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    cursorColor: Colors.green,
                                    controller: controllerQrupadi,
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        labelText: "Məhsulun adı",
                                        labelStyle: TextStyle(color: Colors.black),
                                        hintText: "Məhsulun adıni daxil edin...",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: BorderSide(color: Colors.green,width: 2),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            borderSide: BorderSide(color: Colors.green))),
                                  ),
                                ), /////malin adi
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    cursorColor: Colors.green,
                                    controller: controllerqiymet,
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        labelText: "Qiymət",
                                        labelStyle: TextStyle(color: Colors.black),
                                        hintText: "Məhsulun qiymət daxil edin...",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: BorderSide(color: Colors.green,width: 2),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            borderSide: BorderSide(color: Colors.green))),
                                  ),
                                ), /////malin qiymeti
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child:  TextFormField(
                                    keyboardType: TextInputType.text,
                                    cursorColor: Colors.green,
                                    minLines: 2,
                                    maxLines: 3,
                                    controller: controllerQrupqeyd,
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        labelText: "Qeyd",
                                        labelStyle: TextStyle(color: Colors.black),
                                        hintText: "Məhsulun qeydi daxil edin...",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: BorderSide(color: Colors.green,width: 2),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            borderSide: BorderSide(color: Colors.green))),
                                  ),
                                ), ////mal qeyd
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.red, backgroundColor: Colors.white, padding: EdgeInsets.all(5),
                                    elevation: 5,
                                    minimumSize: Size(100, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    _deleteMeshulByName(model);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Qrupu sil")),
                              const SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.green, backgroundColor: Colors.white, padding: EdgeInsets.all(5),
                                    elevation: 5,
                                    minimumSize: Size(100, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  onPressed: () {}, child: const Text("Dəyis")),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }


  Future _deleteMeshulByName(ModelMehsullar modelQrupadi) async {
    await SqlDatabase.db.deleteMehsulByName(modelQrupadi);
    Fluttertoast.showToast(
        msg: "Melumat ugurla silindi", toastLength: Toast.LENGTH_LONG);
    setState(() {
      getDataFromDp();
    });
  }


  Material customButton(
      BuildContext context, String text, IconData icon, double size) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: SizeConfig.screenWidth! * size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: Colors.green,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: InkWell(
          splashColor: Colors.black,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: SizeConfig.screenWidth! * 0.15),
                    child: Text(text,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textsize18SP,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Icon(icon, color: Colors.white.withOpacity(1))
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ScreenYeniMehsul(
                  callback: (){
                    getDataFromDpAnaqrup();
                    getDataFromDp();
                  },
                      gonderis: "meh",
                      anaqrup: widget.anaqrup,
                    )));
          },
          onHover: (value) {
            setState(() {
              ishover = value;
            });
          },
        ),
      ),
    );
  }

  void callBack(){
    getDataFromDpAnaqrup();
    getDataFromDp();
  }
}
