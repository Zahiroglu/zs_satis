import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/anbar/model_qrup.dart';
import 'package:zs_satis/anbar/screen_anbarcesid.dart';
import 'package:zs_satis/anbar/screen_yenimehsul.dart';
import 'package:zs_satis/anbar/screen_yeniqrup.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/esas_sehfe/enum_drawerIndex.dart';
import 'model_mehsullar.dart';

class ScreenEsasSehfeAnbarAnaqrup extends StatefulWidget {
  ScreenEsasSehfeAnbarAnaqrup({Key? key}) : super(key: key);

  @override
  _ScreenEsasSehfeAnbarAnaqrupState createState() =>
      _ScreenEsasSehfeAnbarAnaqrupState();
}

class _ScreenEsasSehfeAnbarAnaqrupState
    extends State<ScreenEsasSehfeAnbarAnaqrup> {
  List<ModelQrupadi> list_qruplar = [];
  List<ModelMehsullar> list_mallar = [];
  List<ModelMehsullar> list_mallarUmumi = [];
  List<ModelMehsullar> list_mallarStokdaolan = [];
  List<ModelMehsullar> list_mallarstokout = [];
  bool isloading = true;
  bool melumattapilmadi = true;
  bool basliqtapildi = false;
  DrawerIndex? drawerIndex;
  ModelSenedTotal? modelSenedTotal;

  @override
  void initState() {
    SqlDatabase.db.init();
    SqlDatabase.db.getAllRecord();
    _ilkAnaQrupuDoldur();
    super.initState();
  }

  Future _ilkAnaQrupuDoldur() async {
    setState(() {
      isloading = true;
      melumattapilmadi = true;
      basliqtapildi = false;
      modelSenedTotal=null;
      list_qruplar.clear();
      list_mallarstokout.clear();
      list_mallarStokdaolan.clear();
      list_mallar.clear();
      list_mallarUmumi.clear();
    });
    // ModelQrupadi modela = await SqlDatabase.db.getAllAnaQruplarUmumicesidler(
    //     "Ümumi Çeşidlər", "Butun cesidler burada");
    // list_qruplar.add(modela);
    _anaqruplariGetir();
    _basliqMelumatiDoldur();
  }

  Future _anaqruplariGetir() async {
    await SqlDatabase.db.getAllAnaQruplar().then((value) => {
              if (value.isNotEmpty)
                {
                  melumattapilmadi = true,
                  value.forEach((element) {
                    setState(() {
                      list_qruplar.add(element);
                    });
                  })
                }
              else
                {melumattapilmadi = true}
            }).whenComplete(() => {isloading = false});
    setState(() {});
  }

  Future _basliqMelumatiDoldur() async {
    ModelMehsullar modelSened;
    await SqlDatabase.db.getAllMehsulRapor().then((value) => {
      if(value.listMehsullar!.isNotEmpty){
      modelSenedTotal=value,
      for(int i=0;i<value.listMehsullar!.length;i++){
        basliqtapildi=true,
        modelSened=value.listMehsullar!.elementAt(i),
        if(int.parse(modelSened.malinSayi.toString().replaceAll(".0", ""))>0){
          list_mallarStokdaolan.add(modelSened),
        }else{
          list_mallarstokout.add(modelSened),
        },
        list_mallarUmumi=value.listMehsullar!,
      }}else{
        basliqtapildi=false,
      }
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      child: SafeArea(
        child: buildContainer_mobile(),
      ),
    );
  }

  RefreshIndicator buildContainer_mobile() {
    return RefreshIndicator(
      color: Colors.green,
      backgroundColor: Colors.white,
      onRefresh: () {
        return _ilkAnaQrupuDoldur();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            margin: EdgeInsets.only(
              left: 40,
              top: 10,
              bottom: 10,
            ),
            alignment: Alignment.center,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search),
                hintText: Shablomsozler().axtarisedin,
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverToBoxAdapter(
              child: wirgetBasliq(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _customItems(list_qruplar.elementAt(index));
                },
                childCount: list_qruplar.length, // 1000 list items
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container wirgetBasliq() {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black87)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          basliqtapildi? Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(modelSenedTotal!.totalehtiyyat.toString()+" Eded",
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: SizeConfig.textsize16SP,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 3,
                          ),
                          Text("total ehtiyyat".toUpperCase(),
                              style: GoogleFonts.lato(
                                  color: Colors.green,
                                  fontSize: SizeConfig.textsize14SP,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(modelSenedTotal!.totalsumma.toString()+" Azn",
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: SizeConfig.textsize16SP,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 3,
                          ),
                          Text("total summa".toUpperCase(),
                              style: GoogleFonts.lato(
                                  color: Colors.green,
                                  fontSize: SizeConfig.textsize14SP,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                SizedBox(
                  height: 5,
                ),
                const Padding(
                  padding:
                  EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 5),
                  child: Divider(
                    height: 2,
                    color: Colors.green,
                    thickness: 2,
                    indent: 2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  margin: const EdgeInsets.all(5),
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      border: Border.all(color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Umumi cesid  : "+modelSenedTotal!.listMehsullar!.length.toString()+" Eded",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: SizeConfig.textsize16SP,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.forward,
                            color: Colors.grey,
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(left: 5, right: 5),
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      border: Border.all(color: Colors.green)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Stokda olanlar  : "+list_mallarStokdaolan.length.toString(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                              color: Colors.green,
                              fontSize: SizeConfig.textsize16SP,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.forward,
                            color: Colors.green,
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      border: Border.all(color: Colors.redAccent)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Stokda olmayanlar : "+list_mallarstokout.length.toString(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                              color: Colors.redAccent,
                              fontSize: SizeConfig.textsize16SP,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.forward,
                            color: Colors.redAccent,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ):SizedBox(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customButton(context, "Yeni Qrup", Icons.group_work, 0.43),
                SizedBox(
                  width: 0,
                ),
                customButtonyenimal(context, "Yeni Mehsul", Icons.add, 0.43)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Center widgetMelumatTapilmadi() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.info,
            color: Colors.red,
            size: 48,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Melumat tapilmadi",
            style: GoogleFonts.lato(
                fontSize: SizeConfig.textsize20SP, color: Colors.red),
          )
        ],
      ),
    );
  }

  Widget _customItems(ModelQrupadi model) {
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
      padding: EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          List<String> list_anaqrup = [];
          for (int i = 0; i < list_mallar.length; i++) {
            String qrupadi = list_mallar.elementAt(i).qrupAdi.toString();
            list_anaqrup.add(qrupadi);
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenAnbarCesid(
                    callBack: () {
                      _callBack();
                    },
                    anaqrup: model.id.toString(),
                  )));
        },
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
                    model.qrupAdi.toString().toUpperCase(),
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: SizeConfig.textsize16SP,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      ShowEditQrupnameDialog(context, model);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.green,
                    ))
              ],
            ),
            const SizedBox(
              height: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              child: Text(
                "Ümumi çeşid sayı : " + model.cesidSayi.toString() + " Çeşid",
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: SizeConfig.textsize14SP,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Total ehtiyyat : " + model.mehsulsayi.toString() + " Ədəd",
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: SizeConfig.textsize14SP,
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black26,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Qeyd : " + model.qruphaqqinda.toString(),
                style: GoogleFonts.lato(
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

  void ShowEditQrupnameDialog(BuildContext context, ModelQrupadi model) {
    TextEditingController controllerQrupadi = TextEditingController();
    TextEditingController controllerQrupqeyd = TextEditingController();
    controllerQrupadi.text = model.qrupAdi.toString();
    controllerQrupqeyd.text = model.qruphaqqinda.toString();
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
              height: SizeConfig.screenHeight! * 0.45,
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
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Text(
                      "Qrup adının dəyişdirilməsi",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.white38,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    cursorColor: Colors.green,
                                    controller: controllerQrupadi,
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        labelText: "Qrup adı",
                                        hintText: "Qrup adini daxil edin...",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 2),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                                color: Colors.green))),
                                  ),
                                ),

                                ///qrup adi
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: TextFormField(
                                    minLines: 2,
                                    maxLines: 3,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Colors.green,
                                    controller: controllerQrupqeyd,
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        labelText: "Qrup qeyd",
                                        hintText: "Qrup qeydi daxil edin...",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 2),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                                color: Colors.green))),
                                  ),
                                ), ////qrup qeyd
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  child: Text(
                                    "QRUPU SIL",
                                    style: GoogleFonts.lato(
                                        fontSize: SizeConfig.textsize16SP),
                                  ),
                                  onPressed: () {
                                    if (model.mehsulsayi! > 0) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Qrupu silmək üçün ona aid bütün çeşidlər silinməlidir");
                                    } else {
                                      _qrupadiniSil(model.qrupAdi.toString());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.red, backgroundColor: Colors.white, padding: EdgeInsets.all(5),
                                    elevation: 5,
                                    minimumSize: Size(100, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ModelQrupadi modelyeni = ModelQrupadi(
                                      id: model.id,
                                      qrupAdi: controllerQrupadi.text,
                                      qruphaqqinda: controllerQrupqeyd.text,
                                    );
                                    _qrupAdimelumatiniDeyis(
                                        modelyeni, model.qrupAdi.toString());
                                  },
                                  child: Text(
                                    "DEYIS",
                                    style: GoogleFonts.lato(
                                        fontSize: SizeConfig.textsize16SP),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.green, backgroundColor: Colors.white, padding: EdgeInsets.all(5),
                                    elevation: 5,
                                    minimumSize: Size(100, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _qrupAdimelumatiniDeyis(
      ModelQrupadi modelQrupadi, String kohneqrupadi) async {
    await SqlDatabase.db
        .updateAnaQrupName(modelQrupadi, kohneqrupadi)
        .whenComplete(() => {
              _qrupAdimelumatiniDeyisInMehsullar(
                  kohneqrupadi, modelQrupadi.qrupAdi.toString()),
            });
  }

  void _qrupAdimelumatiniDeyisInMehsullar(String kohnead, String yeniad) async {
    await SqlDatabase.db
        .updateAnaQrupNameinMehsullar(kohnead, yeniad)
        .whenComplete(() => {
              Navigator.pop(context),
              Fluttertoast.showToast(
                  msg: "Grup melumatlari ugurla deyisdirildi"),
              _ilkAnaQrupuDoldur()
            });
  }

  void _qrupadiniSil(String grupadi) async {
    await SqlDatabase.db.deleteQrupadiByName(grupadi).whenComplete(() => {
          Fluttertoast.showToast(msg: "Grup adi ugurla silindi"),
          Navigator.pop(context),
          _ilkAnaQrupuDoldur()
        });
  }

  Material customButton(
      BuildContext context, String text, IconData icon, double size) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: SizeConfig.screenHeight! * 0.07,
        width: SizeConfig.screenWidth! * size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: Colors.green,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: InkWell(
            splashColor: Colors.black,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: SizeConfig.textsize14SP,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Icon(icon, color: Colors.white.withOpacity(1))
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScreenYeniQrup(
                        callBack: () {
                          _callBack();
                        },
                      )));
            },
          ),
        ),
      ),
    );
  }

  Material customButtonyenimal(
      BuildContext context, String text, IconData icon, double size) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: SizeConfig.screenHeight! * 0.07,
        width: SizeConfig.screenWidth! * size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: Colors.green,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: InkWell(
            splashColor: Colors.black,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: SizeConfig.textsize14SP,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Icon(icon, color: Colors.white.withOpacity(1))
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScreenYeniMehsul(
                      callback: () {
                        _callBack();
                      },
                      anaqrup: "bos",
                      gonderis: "ana")));
            },
          ),
        ),
      ),
    );
  }

  _callBack() {
      _ilkAnaQrupuDoldur();
  }
}
