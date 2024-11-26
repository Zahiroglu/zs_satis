import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/musteriler/model_musteriler.dart';
import 'package:zs_satis/satis/model_carihereket.dart';
import 'package:zs_satis/satis/screen_esassehfesatis.dart';

class ScreenDashbordSatis extends StatefulWidget {
  const ScreenDashbordSatis({Key? key}) : super(key: key);

  @override
  _ScreenDashbordSatisState createState() => _ScreenDashbordSatisState();
}

class _ScreenDashbordSatisState extends State<ScreenDashbordSatis> {
  List<ModelCariHereket> lisCariHereketler = [];
  double totalnetsatis = 0;
  double totalkassa = 0;
  ScrollController? _controller;
  String selectedtarix = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    SqlDatabase.db.init();
    _controller == ScrollController();
    getAlldata();
    // TODO: implement initState
    super.initState();
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  Future getAlldata() async {
    totalnetsatis = 0;
    totalkassa = 0;
    lisCariHereketler = [];
    var nom = DateTime.now();
    String gun = nom.day.toString();
    if(nom.day<10){
      gun = "0"+nom.day.toString();
    }
    lisCariHereketler = await SqlDatabase.db.getAllCariHereketByDay(gun);
    lisCariHereketler.forEach((element) {
      totalnetsatis = totalnetsatis + double.parse(element.netsatis.toString());
      totalkassa = totalkassa + double.parse(element.kassa.toString());
    });
    setState(() {});
  }

  Future getAlldataBySonHefte() async {
    totalnetsatis = 0;
    totalkassa = 0;
    lisCariHereketler = [];
    var nom = DateTime.now();
    DateTime ilkgun = findFirstDateOfTheWeek(nom);
    DateTime songun = findLastDateOfTheWeek(nom);
    print(findFirstDateOfTheWeek(nom));
    print(findLastDateOfTheWeek(nom));
    lisCariHereketler =
        await SqlDatabase.db.getAllCariHereketBySonHefte(ilkgun, songun);
    lisCariHereketler.forEach((element) {
      totalnetsatis = totalnetsatis + double.parse(element.netsatis.toString());
      totalkassa = totalkassa + double.parse(element.kassa.toString());
    });
    setState(() {});
  }

  Future getAlldataBySonAy() async {
    totalnetsatis = 0;
    totalkassa = 0;
    lisCariHereketler = [];
    var nom = DateTime.now();
    String gun = nom.month.toString();
    if(nom.month<10){
      gun = "0"+nom.month.toString();
    }
    lisCariHereketler = await SqlDatabase.db.getAllCariHereketByAy(gun);
    lisCariHereketler.forEach((element) {
      totalnetsatis = totalnetsatis + double.parse(element.netsatis.toString());
      totalkassa = totalkassa + double.parse(element.kassa.toString());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? buildStackPortret(context)
          : buildStackAlbum(context);
    });
  }

  Stack buildStackPortret(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            decoration: BoxDecoration(color: Colors.green, boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  spreadRadius: 5),
            ]),
            height: MediaQuery.of(context).size.height * 0.3,
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.10,
            left: MediaQuery.of(context).size.height * 0.02,
            child: Container(
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        //offset: Offset(0.5,0.4),
                        blurRadius: 5,
                        spreadRadius: 1),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              height: MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, bottom: 5),
                    child: Text("Satis Hesabat".toUpperCase(),
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ), //satis hesabat olan yer
                  Container(
                    height: MediaQuery.of(context).size.height * 0.26,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black26),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 3,
                              spreadRadius: 0.5),
                        ]),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Hesabat Tarixi :",
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 15,
                              ),
                              DropdownButton<String>(
                                underline: Container(
                                  width: 80,
                                  height: 1,
                                  color: Colors.blue,
                                ),
                                isDense: true,
                                alignment: Alignment.topRight,
                                value: "Bugun",
                                elevation: 5,
                                style: TextStyle(color: Colors.black),
                                items: [
                                  'Bugun',
                                  "Son hefte",
                                  "Son Ay"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    if (value.toString() == "Bugun") {
                                      getAlldata();
                                    } else if (value.toString() ==
                                        "Son hefte") {
                                      getAlldataBySonHefte();
                                    }else{
                                      getAlldataBySonAy();
                                    }
                                    selectedtarix = value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ), ////tarix secilen row
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Divider(
                            height: 1,
                            indent: 2,
                            color: Colors.grey,
                            thickness: 2,
                          ),
                        ), /////devider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ScreenEsasSehfeSatis(
                                          callBacka: (){
                                            _callBack();
                                          },
                                          model_musteri: ModelMusteriler(isclecked: false),
                                          gonderis: "esas",
                                        )));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.green,
                                          offset: Offset(2, 2),
                                          blurRadius: 2,
                                          spreadRadius: 1),
                                    ],
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                height: 100,
                                width: 120,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outlined,
                                        color: Colors.green,
                                        size: 36,
                                      ),
                                      Text(
                                          totalnetsatis.toStringAsFixed(2) +
                                              "  ₼",
                                          style: GoogleFonts.lato(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                      Text("NET SATIS",
                                          style: GoogleFonts.lato(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.blue,
                                        offset: Offset(2, 2),
                                        blurRadius: 2,
                                        spreadRadius: 1),
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              height: 100,
                              width: 120,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outlined,
                                      color: Colors.blue,
                                      size: 36,
                                    ),
                                    Text(totalkassa.toStringAsFixed(2) + "  ₼",
                                        style: GoogleFonts.lato(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    Text("KASSA",
                                        style: GoogleFonts.lato(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ), ////add kassa ve satis buttonlari
                      ],
                    ),
                  ) //umumi orta gorunus olan yer
                ],
              ),
            )),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.04,
            left: MediaQuery.of(context).size.height * 0.2,
            child: CircleAvatar(
              radius: 40,
              child: Image.asset(
                "images/zs5.png",
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
            )),
        DraggableScrollableSheet(
          snap: true,
          expand: true,
          initialChildSize: 0.50,
          minChildSize: 0.50,
          maxChildSize: 0.70,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: scrollController,
              child: widgetListFakturalar(scrollController),
            );
          },
        ),
      ],
    );
  }

  SafeArea buildStackAlbum(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              border: Border.all(color: Colors.grey),
            ),
            // padding: EdgeInsets.only(top: 10),
            child: Placeholder(),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.grey),
            ),
            padding: EdgeInsets.only(top: 10),
            child: Placeholder(),
          )
        ],
      ),
    );
  }

  Widget widgetListFakturalar(ScrollController scrollController) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
          color: Colors.green.shade100,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: Offset(2, 1),
                spreadRadius: 2)
          ],
          border: Border.all(color: Colors.green.shade100),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      margin: EdgeInsets.only(top: 5, left: 1, right: 1),
      padding: EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              width: 40,
              height: 5,
            ),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   height: 60,
            //   color: Colors.transparent,
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Fakturalar ("+lisCariHereketler.length.toString()+")",
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: "Tezlikle hazir olacaq",
                              toastLength: Toast.LENGTH_LONG);
                        },
                        child: Text(
                            "Hamisi (" +
                                lisCariHereketler.length.toString() +
                                ")",
                            style: GoogleFonts.lato(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),

                    ///
                    shrinkWrap: true,

                    ///
                    scrollDirection: Axis.vertical,

                    ///
                    padding: EdgeInsets.all(2),
                    controller: _controller,
                    itemCount: lisCariHereketler.length > 4
                        ? 4
                        : lisCariHereketler.length,
                    itemBuilder: (context, index) {
                      return widgetItemsFakturalar(
                          lisCariHereketler.elementAt(index));
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox widgetItemsFakturalar(ModelCariHereket model) {
    String herekettipi = "";
    if (model.herekttipi == "1") {
      herekettipi = "KASSA";
    } else {
      herekettipi = "Satis";
    }
    return SizedBox(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 2, right: 2, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey, offset: Offset(2, 2), blurRadius: 2)
            ],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: herekettipi == "KASSA" ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      herekettipi,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(height: 1,width:90,color: Colors.black,),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      "F/" +
                          model.fakturakodu.toString() +
                          " | S:" +
                          model.id.toString(),
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      model.createDate.toString().substring(0, 10),
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.55,
              padding: EdgeInsets.all(2),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Tesdiq :",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                      model.tesdiqleme!
                          ? Icon(
                              Icons.verified_rounded,
                              color: Colors.green,
                              size: 14,
                            )
                          : Icon(
                              Icons.unpublished_rounded,
                              color: Colors.red,
                              size: 14,
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            model.brutmebleg!.toStringAsFixed(2),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Brut".toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            model.endirimmebleg!.toStringAsFixed(2),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Endirim".toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            model.netsatis!.toStringAsFixed(2),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Net satis".toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _callBack() {
    getAlldata();
    setState(() {
    });
  }
}
