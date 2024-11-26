import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/anbar/model_stockhereket.dart';
import 'package:zs_satis/constandlar/app_theme.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/musteriler/model_musteriler.dart';
import 'package:zs_satis/satis/model_carihereket.dart';
import 'package:zs_satis/satis/model_satis.dart';
import 'modul_expendedlist/widget_satisexpended.dart';
import 'widget_kassa.dart';
import 'widget_musteriler.dart';

class ScreenEsasSehfeSatis extends StatefulWidget {
  Function callBacka;
  String gonderis;
  ModelMusteriler model_musteri = ModelMusteriler(isclecked: false);

  ScreenEsasSehfeSatis({Key? key,
    required this.gonderis,
    required this.model_musteri,
    required this.callBacka})
      : super(key: key);

  @override
  _ScreenEsasSehfeSatisState createState() => _ScreenEsasSehfeSatisState();
}

class _ScreenEsasSehfeSatisState extends State<ScreenEsasSehfeSatis> {
  bool gonderis = false;
  ModelMusteriler? selected_musteri = ModelMusteriler(isclecked: false);
  List<ModelMusteriler> list_musteriler = [];
  List<ModelSatis> list_sifarisler = [];
  List<ModelSatis> list_secilensifarisler = [];
  bool ismusteriselected = false;
  bool islistvisible = false;
  bool backgoster = true;
  bool kassaodendi = false;
  bool qaytarmaedildi = false;
  bool buttomsheetgorunsun = false;
  double totalSatis = 0;
  double totalEndirim = 0;
  double totalNetsatis = 0;
  double totalXeyir = 0;
  double totalkassa = 0;
  ModelCariHereket modelkassa = ModelCariHereket();
  String stId = "0";
  bool tesdiqle = false;
  double ilkinqaliq = 0;
  double elavesatissumma = 0;
  double odenilenmebleg = 0;
  double qaliqborc = 0;
  double qaytarma = 0;

  @override
  void initState() {
    SqlDatabase.db.init();
    getlastidFromSatis();
    if (widget.gonderis == "esas") {
      setState(() {
        backgoster = false;
        ismusteriselected = false;
        selected_musteri = ModelMusteriler(isclecked: false);
        gonderis = true;
      });
    } else {
      setState(() {
        backgoster = true;
        ismusteriselected = true;
        selected_musteri = widget.model_musteri;
        gonderis = false;
      });
    }
    // TODO: implement initState
    super.initState();
  }

  setArraylistSifarisler() {
    list_sifarisler = [];
    if (list_secilensifarisler.isNotEmpty) {
      islistvisible = true;
    }
    for (int i = 0; i < list_secilensifarisler.length; i++) {
      setState(() {
        ModelSatis model = list_secilensifarisler.elementAt(i);
        totalSatis = totalSatis + double.parse(model.satissumma.toString());
        totalEndirim =
            totalEndirim + double.parse(model.satisendirim.toString());
        totalNetsatis = totalNetsatis + double.parse(model.netsatis.toString());
        totalXeyir = totalXeyir + double.parse(model.satisxeyir.toString());
        list_sifarisler.add(model);
      });
    }
  }

  getlastidFromSatis() async {
    int? reqem = await SqlDatabase.db.getLasFakturaId();
    setState(() {
      stId = "ZS07" + reqem.toString();
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
                if (tesdiqle) {
                  _melumatlariServereYaz();
                } else {
                  _showMyDialog("Xəta",
                      "Hereket elave etmeden tesdiqle ede bilmezsiniz!");
                }
              },
              child: Container(
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Text(
                      "Tesdiqle",
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () {
              widget.callBacka.call();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
            )),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Yeni satis | "),
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              child: Text(
                stId,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          widgetMusteriAdi(),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ismusteriselected ? widgetmehsulElaveEt() : SizedBox(),
                islistvisible
                    ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 15, bottom: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("Satis detay",
                                textAlign: TextAlign.right,
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: SizeConfig.textsize16SP,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                                "Hamisi : " +
                                    list_sifarisler.length.toString(),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.lato(
                                  color: Colors.blue,
                                  fontSize: SizeConfig.textsize16SP,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: list_sifarisler.length > 3 ? 250 : (double.parse(
                          list_sifarisler.length.toString()) * 90),
                      width: double.infinity,
                      child: ListView.builder(
                          itemCount: list_sifarisler.length,
                          itemBuilder: (context, index) {
                            return widgetTotalSatisDetay(
                                list_sifarisler.elementAt(index));
                          }),
                    ),
                  ],
                )
                    : SizedBox(),
                SizedBox(height: 10,),
                ismusteriselected
                    ? kassaodendi
                    ? widgetTotalKassaDetay()
                    : SizedBox()
                    : SizedBox(),
              ],
            ),
          )
        ],
      ),
      bottomSheet: buttomsheetgorunsun
          ? Container(
        padding: EdgeInsets.only(right: 15, top: 5, bottom: 5),
        height: 70,
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                "Total satis : " +
                    elavesatissumma.toStringAsFixed(2) +
                    Shablomsozler().valyuta,
                textAlign: TextAlign.right,
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                )),
            kassaodendi
                ? Text(
                "Kassa : " +
                    odenilenmebleg.toStringAsFixed(2) +
                    Shablomsozler().valyuta,
                textAlign: TextAlign.right,
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ))
                : SizedBox(),
            qaytarmaedildi
                ? Text(
                "Qaytarma : " +
                    qaliqborc.toStringAsFixed(2) +
                    Shablomsozler().valyuta,
                textAlign: TextAlign.right,
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ))
                : SizedBox(),
            Text(
                "Son qaliq : " +
                    qaliqborc.toStringAsFixed(2) +
                    Shablomsozler().valyuta,
                textAlign: TextAlign.right,
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      )
          : SizedBox(),
    );
  }

  Column widgetMusteriAdi() {
    return ismusteriselected
        ? Column()
        : Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
          margin: EdgeInsets.all(5),
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Musteri secin",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: SizeConfig.textsize16SP,
                      fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            WidgetMusteriler(
                              getselectedmusteri:
                                  (ModelMusteriler musteri) {
                                setState(() {
                                  selected_musteri = musteri;
                                  ismusteriselected = true;
                                  ilkinqaliq = double.parse(
                                      musteri.sonborc!.toStringAsFixed(2));
                                });
                              },
                            )));
                  },
                  icon: const Icon(
                    Icons.add_circle_outlined,
                    color: Colors.green,
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Stack widgetmehsulElaveEt() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: Colors.black),
              gradient: AppTheme.bacgroundgradient),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(selected_musteri!.carikod.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                              selected_musteri!.musteriadi
                                  .toString()
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.bar_chart,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Qaliq borc :",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(
                            width: 10,
                          ),
                          elavesatissumma > 0
                              ? Row(
                            children: [
                              Text(
                                  selected_musteri!.sonborc.toString() +
                                      Shablomsozler().valyuta,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "  +  " +
                                      elavesatissumma.toStringAsFixed(2) +
                                      Shablomsozler().valyuta,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                              : Text(
                              totalkassa.toStringAsFixed(2) +
                                  Shablomsozler().valyuta,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          list_secilensifarisler.clear();
                          list_sifarisler.clear();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  WidgetSatishExpended(
                                      getselectedsifaris: (value) {
                                        _callBackSatis(value);
                                      },
                                      musterikodu:
                                      selected_musteri!.carikod.toString(),
                                      fakturaId: stId),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(2, 2),
                                    blurRadius: 3,
                                    spreadRadius: 1),
                              ],
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outlined,
                                  color: Colors.green,
                                  size: 24,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("SATIS",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          _callBackKassa();
                        },
                        splashColor: Colors.red,
                        child: Ink(
                          color: Colors.black,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                      spreadRadius: 1),
                                ],
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle_outlined,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("KASSA",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(2, 2),
                                  blurRadius: 3,
                                  spreadRadius: 1),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outlined,
                                color: Colors.red,
                                size: 24,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("QAYTARMA",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ), ////ad
              ],
            ),
          ),
        ),
        Positioned(
            top: 12,
            right: 15,
            child: IconButton(
              onPressed: () {
                setState(() {
                  ismusteriselected = false;
                  list_sifarisler.clear();
                  islistvisible = false;
                  totalEndirim = 0;
                  totalSatis = 0;
                  totalNetsatis = 0;
                });
              },
              icon: Icon(
                Icons.clear,
                size: 32,
              ),
              color: Colors.red,
            ))
      ],
    );
  }

  Padding widgetTotalSatisDetay(ModelSatis elementAt) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 1, offset: Offset(1, 1))
                ],
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(elementAt.mehsuladi.toString(),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                          "Total Satış : " +
                              elementAt.satissumma!.toStringAsFixed(2) +
                              Shablomsozler().valyuta,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Satis Miqdar :" +
                              elementAt.satismiqdari!.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          )),
                      Text(
                          "Total endirim : " +
                              elementAt.satisendirim!.toStringAsFixed(2) +
                              Shablomsozler().valyuta,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          "Total net satis : " +
                              elementAt.netsatis!.toStringAsFixed(2) +
                              Shablomsozler().valyuta,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column widgetTotalKassaDetay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 10, right: 10, top: 15, bottom: 1),
          child: Text("Kassa detay",
              textAlign: TextAlign.right,
              style: GoogleFonts.lato(
                color: Colors.black,
                fontSize: SizeConfig.textsize16SP,
                fontWeight: FontWeight.bold,
              )),
        ),
        InkWell(
          onTap: () {
            _callBackKassa();
          },
          child: Container(
            margin: EdgeInsets.all(5),
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 1, offset: Offset(1, 1))
                ],
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Ilkin qaliq : " +
                              selected_musteri!.sonborc!.toStringAsFixed(2) +
                              Shablomsozler().valyuta,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                          "Odenis : " +
                              odenilenmebleg.toStringAsFixed(2) +
                              Shablomsozler().valyuta,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                      "Qaliq : " +
                          qaliqborc.toStringAsFixed(2) +
                          Shablomsozler().valyuta,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.lato(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 3,
                  ),
                  Text("Tarix  : " + DateTime.now().toString().substring(0, 10),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.lato(
                        color: Colors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _callBackSatis(List<ModelSatis> sifarisler) {
    elavesatissumma = 0;
    setState(() {
      sifarisler.forEach((element) {
        elavesatissumma =
            elavesatissumma + double.parse(element.netsatis.toString());
        list_secilensifarisler.add(element);
      });
      setArraylistSifarisler();
      if (elavesatissumma > 0) {
        buttomsheetgorunsun = true;
      } else {
        buttomsheetgorunsun = false;
      }
      _totalMelumatlarideyis();
    });
    // setState(() {
    //   if (sifaris.mehsulkodu!.isNotEmpty) {
    //     list_sifarisler.add(sifaris);totalSatis = totalSatis + double.parse(sifaris.satissumma.toString());
    //     totalEndirim =
    //         totalEndirim + double.parse(sifaris.satisendirim.toString());
    //     totalNetsatis =
    //         totalNetsatis + double.parse(sifaris.netsatis.toString());
    //     totalXeyir = totalXeyir + double.parse(sifaris.satisxeyir.toString());
    //   }
    //   if (list_sifarisler.isNotEmpty) {
    //     islistvisible = true;
    //   }
    // });
  }

  _callBackKassa() {
    kassaodendi = false;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            WidgetKassa(
              callback: (value, odenilenmebl) {
                odenilenmebleg = odenilenmebl;
                modelkassa = value;
                kassaodendi = true;
                setState(() {
                  _totalMelumatlarideyis();
                });
              },
              modemusteri: selected_musteri!,
              faktura: stId,
            )));
    setState(() {});
  }

  _totalMelumatlarideyis() {
    qaliqborc = 0;
    setState(() {
      if (list_secilensifarisler.isNotEmpty) {
        if (kassaodendi) {
          tesdiqle = true;
          buttomsheetgorunsun = true;
          qaliqborc = (ilkinqaliq + elavesatissumma) - odenilenmebleg;
        } else {
          tesdiqle = true;
          buttomsheetgorunsun = true;
          qaliqborc = (ilkinqaliq + elavesatissumma);
        }
      } else {
        if (kassaodendi) {
          tesdiqle = true;
          buttomsheetgorunsun = true;
          qaliqborc = (ilkinqaliq - odenilenmebleg);
        } else {
          print("Dorduncu sert ondedi:");
          qaliqborc = ilkinqaliq;
          print("qaliqborc:" + qaliqborc.toString());
        }
      }
    });
  }

  _melumatlariServereYaz() async {
    ModelSatis modelSatis;
    _saveCariHereketTodb(list_sifarisler);
    double sumnetsatis = list_sifarisler.map((expense) => expense.satissumma).fold(0, (prev, amount) => prev + amount!);
    print("sumnetsatis"+sumnetsatis.toString());
    double sumxeyir = list_sifarisler.map((expense) => expense.satisxeyir).fold(0, (prev, amount) => prev + amount!);
    print("sumxeyir"+sumxeyir.toString());
    double sumendirim = list_sifarisler.map((expense) => expense.satisendirim).fold(0, (prev, amount) => prev + amount!);
    print("sumendirim"+sumendirim.toString());
    double satismiqdar = list_sifarisler.map((expense) => expense.satismiqdari).fold(0, (prev, amount) => prev + amount!);
    print("satismiqdar"+satismiqdar.toString());
    ModelSatis model = ModelSatis(
      netsatis: sumnetsatis,
      tesdiqleme: false,
      mehsulkodu: "bos",
      vaxt: DateTime.now(),
      satisxeyir: sumxeyir,
      satismiqdari: satismiqdar,
      negdSayis: false,
      satisendirim: sumendirim,
      mustericarikodu: list_sifarisler.elementAt(0).mustericarikodu,
      fakturanomresi: stId,
    );
    await SqlDatabase.db.addSatisToDb(model).whenComplete(() => {
      _butunMelumatlariSifirla(),
        Fluttertoast.showToast(msg: "Melumatlar ugurla daxil edildi"),
    getlastidFromSatis(),
    setState(() {})
    });
    for (int i = 0; i < list_sifarisler.length; i++) {
    modelSatis = list_sifarisler.elementAt(i);
    _saveStocksayiTodb(modelSatis);
    }
  }
 _butunMelumatlariSifirla(){
   ismusteriselected = false;
   islistvisible = false;
   totalSatis = 0;
   totalEndirim = 0;
   totalNetsatis = 0;
   list_sifarisler.clear();
   list_secilensifarisler.clear();
   kassaodendi = false;
   qaytarmaedildi = false;
   totalkassa = 0;
   elavesatissumma = 0;
   odenilenmebleg = 0;
   qaliqborc=0;
   buttomsheetgorunsun=false;
   tesdiqle=false;
 }
  void _saveStocksayiTodb(ModelSatis modelSatis) async {
    ModelStockHereket modelhereket = ModelStockHereket(
      cixissayi: modelSatis.satismiqdari,
      groupid: modelSatis.groupid,
      mehsulkodu: modelSatis.mehsulkodu,
      createDate: DateTime.now(),
      gisirsayi: 0,
      herekettipi: "0",
      musterikodu: modelSatis.mustericarikodu,
      ilkinqaliq: modelSatis.ilkinstoksayi,
      sonqaliq: modelSatis.sonstoksayi,
      tesdiqlenme: false,
    );
    await SqlDatabase.db
        .addStockHerekerToDb(modelhereket)
        .whenComplete(() => {});
  }

  void _saveCariHereketTodb(List<ModelSatis> listsatis) async {
    double totalbrut = 0;
    double totalendirim = 0;
    double totalnetsatis = 0;
    listsatis.forEach((element) {
      totalbrut = totalbrut + double.parse(element.satissumma.toString());
      totalendirim =
          totalendirim + double.parse(element.satisendirim.toString());
      totalnetsatis = totalnetsatis + double.parse(element.netsatis.toString());
    });
    ModelCariHereket cariHereket = ModelCariHereket(
      carikod: selected_musteri!.carikod,
      createDate: DateTime.now(),
      brutmebleg: totalbrut,
      endirimmebleg: totalendirim,
      netsatis: totalnetsatis,
      fakturakodu: stId,
      herekttipi: "0",
      kassa: 0,
      tesdiqleme: false,
    );
    await SqlDatabase.db.addCariHerekerToDb(cariHereket).whenComplete(() {
      if (odenilenmebleg > 0) {
        SqlDatabase.db.addCariHerekerToDb(modelkassa);
      }
    });
  }

  Future<void> _showMyDialog(String alerbasliq, String alertmesaj) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alerbasliq),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(alertmesaj),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Bagla"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
