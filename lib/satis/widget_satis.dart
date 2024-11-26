import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zs_satis/anbar/model_mehsullar.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/databases/slq_database.dart';
import 'package:zs_satis/satis/model_satis.dart';

class WidgetSatish extends StatefulWidget {
  Function(ModelSatis) getselectedsifaris;
  String musterikodu;
  String fakturaId;

  WidgetSatish({Key? key, required this.getselectedsifaris,required this.musterikodu,required this.fakturaId}) : super(key: key);

  @override
  _WidgetSatishState createState() => _WidgetSatishState();
}

class _WidgetSatishState extends State<WidgetSatish> {
  List<ModelMehsullar> list_mehsullar = [];
  int selectedindex = 0;
  TextEditingController cn_miqdar = TextEditingController();
  TextEditingController cn_endirim = TextEditingController();
  bool mehsulsecildi = false;
  int qaliqstok = 0;
  double endirimsumma = 0;
  double summa = 0;
  double summatotal = 0;

  @override
  void initState() {
    SqlDatabase.db.init();
    getDataMehsullarFromDp();
    // TODO: implement initState
    super.initState();
  }

  Future getDataMehsullarFromDp() async {
    list_mehsullar.clear();
    await SqlDatabase.db.getAllMallar().then((value) => {
          value.forEach((element) {
            list_mehsullar.add(element);
          })
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: true,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          margin: EdgeInsets.only(
            left: 1,
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
      body: Container(
        child: ListView.builder(
            itemCount: list_mehsullar.length,
            itemBuilder: (context, index) {
              return buildItemList(list_mehsullar.elementAt(index), index);
            }),
      ),
    );

  }

  Material buildItemList(ModelMehsullar model, int index) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.red.withOpacity(0.8),
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedindex = index;
            mehsulsecildi = true;
            showEdilMehsulDialog(context, model);
          });
          // widget.getselectedsifaris.call(model);
          //Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.5,
                  color: Colors.white38,
                  offset: Offset(2, 2),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          model.id.toString(),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.textsize16SP),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 20,
                          width: 1,
                          child: Container(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          model.malinAdi.toString(),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.textsize16SP),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Qaliq : " + model.malinSayi.toString(),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.textsize12SP),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Deyer : " + model.mayaDeyeri.toString(),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.textsize12SP),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          height: 20,
                          width: 1,
                          child: Container(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Qiymet : " + model.malinQitmeti.toString(),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.textsize12SP),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return Container(
    //   child: Row(
    //     children: [
    //       Text(
    //         model.carikod.toString(),
    //         style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: SizeConfig.textsize16SP),
    //         textAlign: TextAlign.center,
    //       ),
    //       Text(
    //         model.musteriadi.toString(),
    //         style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: SizeConfig.textsize16SP),
    //         textAlign: TextAlign.center,
    //       ),
    //     ],
    //   ),
    // );
  }

  void showEdilMehsulDialog(BuildContext context, ModelMehsullar model) {
    double screenheit = SizeConfig.screenHeight! * 0.55;
    List<bool> isSelected;
    isSelected = [false, true];
    bool indexselectedtoggle = true;
    cn_miqdar.text = "0";
    int malinkohnesayi = int.parse(model.malinSayi.toString().replaceAll(".0", ""));
    int secilensay = int.parse(cn_miqdar.text.toString());
    double qiymet = double.parse(model.malinQitmeti.toString().replaceAll(".0", ""));
    if (mehsulsecildi) {
      qaliqstok = malinkohnesayi - secilensay;
      summa = secilensay * qiymet;
    } else {
      qaliqstok = 0;
      summa = 0;
    }
    bool endirim = false;
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              child: Container(
                height: screenheit,
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
                    Column(
                      children: [
                        Image.asset(
                          "images/product.png",
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("" + model.malinAdi.toString().toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: SizeConfig.textsize14SP,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  )),
                            ],
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
                      ],
                    ),
                    SizedBox(height: 5),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Miqdar sec :",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: SizeConfig.textsize14SP,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 1),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            secilensay = int.parse(cn_miqdar.text.toString());
                                            secilensay = secilensay - 1;
                                            cn_miqdar.text = secilensay.toString();
                                            qaliqstok = malinkohnesayi - secilensay;
                                            summa = secilensay * qiymet;
                                            if (endirim) {
                                              if (indexselectedtoggle) {
                                                endirimsumma = double.parse(cn_endirim.text.toString());
                                                summatotal=summa-endirimsumma;
                                              } else {
                                                endirimsumma = summa * double.parse(cn_endirim.text.toString()) / 100;
                                                summatotal=summa-endirimsumma;
                                              }
                                            }else{
                                              summatotal=summa;
                                              endirimsumma=0;
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        )),
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      height: 60,
                                      width: 70,
                                      color: Colors.white,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        cursorColor: Colors.green,
                                        controller: cn_miqdar,
                                        textAlign: TextAlign.center,
                                        onChanged: (deyer) {
                                         setState(() {
                                            secilensay = int.parse(deyer.toString());
                                            qaliqstok = malinkohnesayi - secilensay;
                                            summa = secilensay * qiymet;
                                            if (endirim) {
                                              if (indexselectedtoggle) {
                                                endirimsumma = double.parse(cn_endirim.text.toString());
                                                summatotal = summa - endirimsumma;
                                                print("summa :"+summa.toString());
                                                print("endirimsumma :"+endirimsumma.toString());
                                                print("summatotal :"+summatotal.toString());
                                              } else {
                                                endirimsumma = (summa * double.parse(cn_endirim.text.toString())) / 100;
                                                summatotal = summa - endirimsumma;
                                                print("summa :"+summa.toString());
                                                print("endirimsumma :"+endirimsumma.toString());
                                                print("summatotal :"+summatotal.toString());
                                              }
                                            } else {
                                              summatotal = summa;
                                              endirimsumma = 0;
                                            }
                                          });
                                        },
                                        decoration: InputDecoration(
                                            fillColor: Colors.white.withOpacity(0.5),
                                            filled: true,
                                            labelStyle: TextStyle(
                                                color: Colors.black),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 2),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    25.0),
                                                borderSide: BorderSide(
                                                    color: Colors.green))),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            secilensay = int.parse(cn_miqdar.text.toString()) + 1;
                                            cn_miqdar.text = secilensay.toString();
                                            qaliqstok = malinkohnesayi - secilensay;
                                            summa = secilensay * qiymet;
                                            if (endirim) {
                                              if (indexselectedtoggle) {
                                                endirimsumma = double.parse(cn_endirim.text.toString());
                                                summatotal=summa-endirimsumma;
                                              } else {
                                                endirimsumma = summa * double.parse(cn_endirim.text.toString()) / 100;
                                                summatotal=summa-endirimsumma;
                                              }
                                            }else{
                                              summatotal=summa;
                                              endirimsumma=0;
                                              cn_endirim.text="0";
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.green,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ), // Row satis secimi
                        Divider(
                          height: 1,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CheckboxListTile(
                              title: Text("Endirim"),
                              value: endirim,
                              onChanged: (newValue) {
                                setState(() {
                                  endirim = newValue!;
                                  if (endirim) {
                                    screenheit = SizeConfig.screenHeight! * 0.65;
                                  } else {
                                    endirim=false;
                                    endirimsumma=0;
                                    cn_endirim.text="0";
                                    summatotal=summa;
                                    screenheit = SizeConfig.screenHeight! * 0.55;
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .platform, //  <-- leading Checkbox
                            ),
                            endirim
                                ? Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 120,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.green,
                                          controller: cn_endirim,
                                          textAlign: TextAlign.center,
                                          onChanged: (deyer) {
                                            setState(() {
                                              if (endirim) {
                                                if (indexselectedtoggle) {
                                                  endirimsumma = double.parse(deyer.toString());
                                                  summatotal=summa-endirimsumma;
                                                } else {
                                                  endirimsumma = summa * double.parse(deyer.toString()) / 100;
                                                  summatotal=summa-endirimsumma;
                                                }
                                              }else{
                                                endirimsumma=0;
                                                summatotal=summa;
                                              }
                                            });
                                          },
                                          decoration: InputDecoration(
                                              suffix: indexselectedtoggle
                                                  ? Text("₼")
                                                  : Text("%"),
                                              fillColor: Colors.grey[200],
                                              filled: true,
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                              hintText: "Endirim",
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                borderSide: BorderSide(
                                                    color: Colors.green,
                                                    width: 2),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.green))),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      ToggleButtons(
                                        borderColor: Colors.green,
                                        fillColor: Colors.green,
                                        borderWidth: 1,
                                        selectedBorderColor: Colors.grey,
                                        selectedColor: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '%-le',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '₼',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                        onPressed: (int index) {
                                          setState(() {
                                            print("selected"+index.toString());
                                            for (int i = 0; i < isSelected.length; i++)
                                            {isSelected[i] = i == index;}
                                            if (index == 0) {
                                              endirimsumma = summa * double.parse(cn_endirim.text.toString()) / 100;
                                              summatotal=summa-endirimsumma;
                                              indexselectedtoggle = false;
                                            } else if(index==1){
                                              endirimsumma = double.parse(cn_endirim.text.toString());
                                              summatotal=summa-endirimsumma;
                                              indexselectedtoggle = true;
                                            }
                                          });
                                        },
                                        isSelected: isSelected,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ), //Colmn endirim hissesi
                        Divider(
                          height: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Satis Mebleg :" + summa.toStringAsFixed(2)+" ₼",
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Endirim " + endirimsumma.toStringAsFixed(2)+" ₼",
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Total Summa " + summatotal.toStringAsFixed(2)+" ₼",
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                              setState(() {
                                summatotal=0;
                                endirimsumma=0;
                                selectedindex=1;
                                mehsulsecildi = false;
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Legv et")),
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
                            onPressed: () {
                              _listeElaveET(model,summa,summatotal,endirimsumma,double.parse(cn_miqdar.text.toString()));
                            },
                            child: const Text("Daxil et")),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
  _listeElaveET(ModelMehsullar model,double netsumma,double totalsumma,double endirim,double miqdar){
    double mayadeyer=netsumma-(miqdar*double.parse(model.mayaDeyeri!.toStringAsFixed(2))+endirimsumma);
    final now=DateTime.now();
    ModelSatis modelSatis=ModelSatis(
      ilkinstoksayi: model.malinSayi,
      sonstoksayi: model.malinSayi!-miqdar,
      groupid: model.qrupAdi,
      mehsuladi: model.malinAdi,
      netsatis: totalsumma,
      satissumma:netsumma,
      mehsulkodu: model.mehsulkodu,
      fakturanomresi: widget.fakturaId,
      mustericarikodu: widget.musterikodu,
      satisendirim: endirim,
      negdSayis: false,
      satismiqdari: miqdar,
      satisxeyir: mayadeyer,
      vaxt: now
    );
    widget.getselectedsifaris.call(modelSatis);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
